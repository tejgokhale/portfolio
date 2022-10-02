DROP VIEW IF EXISTS m4ol.sms_segments_info;

CREATE VIEW m4ol.sms_segments_info AS

WITH link_click_total AS (
    SELECT profile_id, COUNT(clicked_url) as total_clicks
    FROM m4ol_mc.mc_clicks mc
    GROUP BY 1),
  
  link_click_2021 AS (
    SELECT profile_id, COUNT(clicked_url) as total_clicks_2021
    FROM m4ol_mc.mc_clicks mc
    WHERE created_at::date > '2020-12-31'
    GROUP BY 1), 
  
  link_click_past AS (
    SELECT profile_id, COUNT(clicked_url) as total_clicks_past
    FROM m4ol_mc.mc_clicks mc
    WHERE created_at::date <= '2020-12-31'
    GROUP BY 1),
  
  calls AS (
    SELECT profile_id, COUNT(call_id) as total_calls
    FROM m4ol_mc.mc_calls
    GROUP BY 1),
  
  all_mc_clicks AS (
    SELECT lct.*, lc2.total_clicks_2021, lcp.total_clicks_past
    FROM link_click_total lct
    LEFT JOIN link_click_2021 lc2 ON lc2.profile_id = lct.profile_id
    LEFT JOIN link_click_past lcp ON lcp.profile_id = lct.profile_id),
  
  mc_info_temp AS (
    SELECT a.*, c.total_calls
    FROM all_mc_clicks a
    LEFT JOIN calls c ON c.profile_id = a.profile_id),
  
  calls_temp AS (
    SELECT *
    FROM calls
    
    EXCEPT
    
    SELECT profile_id, total_calls
    FROM mc_info_temp),
  
  all_mc_info AS (
    SELECT *
    FROM mc_info_temp
    
    UNION
    
    SELECT profile_id, NULL AS total_clicks, NULL AS total_clicks_2021, NULL AS total_clicks_past, total_calls
    FROM calls_temp),
  
  contribs_total AS (
    SELECT vanid, COUNT(datecreated) as total_contribs, SUM(amount) as total_contribs_amount
    FROM m4ol_ea.tsm_tmc_contactscontributions_mfol
    GROUP BY 1), 
  
  contribs_total_2021 AS (
    SELECT vanid, COUNT(datecreated) as total_contribs_2021, SUM(amount) as total_contribs_amount_2021
    FROM m4ol_ea.tsm_tmc_contactscontributions_mfol
    WHERE datecreated > '2020-12-31'
    GROUP BY 1), 
  
  contribs_total_past AS (
    SELECT vanid, COUNT(datecreated) as total_contribs_past, SUM(amount) as total_contribs_amount_past
    FROM m4ol_ea.tsm_tmc_contactscontributions_mfol
    WHERE datecreated <= '2020-12-31'
    GROUP BY 1), 
  
  all_contribs AS (
    SELECT ct.*, ct2.total_contribs_2021, ct2.total_contribs_amount_2021, 
    ctp.total_contribs_past, ctp.total_contribs_amount_past
    FROM contribs_total ct
    LEFT JOIN contribs_total_2021 ct2 ON ct2.vanid = ct.vanid
    LEFT JOIN contribs_total_past ctp ON ctp.vanid = ct.vanid),
  
  event_signups_total AS (
    SELECT vanid, COUNT(eventsignupid) as total_signups
    FROM m4ol_ea.tsm_tmc_eventsignups_mfol
    GROUP BY 1), 

  event_signups_2021 AS (
    SELECT vanid, COUNT(eventsignupid) as total_signups_2021
    FROM m4ol_ea.tsm_tmc_eventsignups_mfol 
    WHERE datetimeoffsetbegin::date > '2020-12-31'
    GROUP BY 1), 
  
  event_signups_past AS (
    SELECT vanid, COUNT(eventsignupid) as total_signups_past
    FROM m4ol_ea.tsm_tmc_eventsignups_mfol 
    WHERE datetimeoffsetbegin::date <= '2020-12-31'
    GROUP BY 1), 
  
  all_events AS (
    SELECT est.*, es2.total_signups_2021, esp.total_signups_past
    FROM event_signups_total est
    LEFT JOIN event_signups_2021 es2 ON es2.vanid = est.vanid
    LEFT JOIN event_signups_past esp ON esp.vanid = est.vanid),
  
  van_info_temp AS (
    SELECT c.*, a.total_signups, a.total_signups_2021, a.total_signups_past
    FROM all_contribs c
    LEFT JOIN all_events a ON a.vanid = c.vanid), 

  events_temp AS (
    SELECT *
    FROM all_events
    
    EXCEPT
    
    SELECT vanid, total_signups, total_signups_2021, total_signups_past
    FROM van_info_temp),

  all_van_info AS (
    SELECT *
    FROM van_info_temp
    
    UNION
    
    SELECT vanid, NULL AS total_contribs, NULL AS total_contribs_amount, NULL AS total_contribs_2021, 
    NULL AS total_contribs_amount_2021, NULL AS total_contribs_past, NULL AS total_contribs_amount_past, 
    total_signups, total_signups_2021, total_signups_past
    FROM events_temp), 
  
  mc_ea_match AS (
    SELECT m.profile_id, m.phone_number, c.vanid
    FROM m4ol_mc.mc_profiles m
    INNER JOIN m4ol_ea.tsm_tmc_contactsphones_mfol c ON c.phone = SUBSTRING(m.phone_number, 2, 11)),
  
  only_match_info AS (
    SELECT m.*, a.total_clicks, a.total_clicks_2021, a.total_clicks_past, a.total_calls,
    v.total_signups, v.total_signups_2021, v.total_signups_past, v.total_contribs, v.total_contribs_amount,
    v.total_contribs_2021, v.total_contribs_amount_2021, v.total_contribs_past, v.total_contribs_amount_past
    FROM mc_ea_match m
    LEFT JOIN all_mc_info a ON a.profile_id = m.profile_id
    LEFT JOIN all_van_info v ON v.vanid = m.vanid),
  
  no_match_temp AS (
    SELECT * 
    FROM all_mc_info
    
    EXCEPT
    
    SELECT profile_id, total_clicks, total_clicks_2021, total_clicks_past, total_calls
    FROM only_match_info),
  
  match_and_no_match AS (
    SELECT *
    FROM only_match_info
    
    UNION
    
    SELECT profile_id, NULL AS phone_number, NULL AS vanid, total_clicks, total_clicks_2021, total_clicks_past, 
    total_calls, NULL AS total_signups, NULL AS total_signups_2021, NULL AS total_signups_past, 
    NULL AS total_contribs, NULL AS total_contribs_amount, NULL AS total_contribs_2021, 
    NULL AS total_contribs_amount_2021, NULL AS total_contribs_past, NULL AS total_contribs_amount_past
    FROM no_match_temp),
  
  all_info AS (
    SELECT m.*, p.status, p.created_at, p.source_type, p.source_name, p.opted_out_at, p.opted_out_source
    FROM match_and_no_match m
    INNER JOIN m4ol_mc.mc_profiles p ON p.profile_id = m.profile_id
    WHERE p.status = 'Active Subscriber'),
  
  segments AS (
    SELECT *, 
      CASE 
        WHEN total_contribs IS NULL AND total_clicks IS NULL AND total_signups IS NULL AND total_calls IS NULL 
          THEN 'no_activity'
        WHEN total_contribs_2021 IS NOT NULL AND (total_clicks > 1 OR total_calls IS NOT NULL 
        OR total_signups > 1)
          THEN 'recent_donors_high_activity' 
        WHEN total_contribs_2021 IS NOT NULL AND (total_clicks = 1 OR total_signups = 1) AND total_calls IS NULL
          THEN 'recent_donors_low_activity'
        WHEN total_contribs_past IS NOT NULL AND total_contribs_2021 IS NULL AND (total_clicks_2021 IS NOT NULL OR
        total_calls IS NOT NULL OR total_signups_2021 IS NOT NULL)
          THEN 'old_donors_recent_activity'
        WHEN total_contribs_past IS NOT NULL AND total_contribs_2021 IS NULL AND ((total_clicks_2021 IS NULL
        AND total_clicks_past IS NOT NULL) OR (total_signups_2021 IS NULL AND total_signups_past IS NOT NULL)) AND
        total_calls IS NULL
          THEN 'old_donors_old_activity'
        WHEN total_contribs IS NOT NULL
          THEN 'donors_no_activity'
        WHEN total_contribs IS NULL AND (total_clicks > 1 OR total_calls >= 1 OR total_signups > 1)
          THEN 'high_activity_not_donors'
        WHEN total_contribs IS NULL
          THEN 'low_activity_not_donors'
        ELSE NULL
      END AS segment
    FROM all_info)

SELECT *
FROM segments;
