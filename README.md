# Tej Gokhale - Portfolio

Hello! This includes some selected projects from my role as Data Director at March For Our Lives and freelance gigs.

## [RFM Model & Cluster Analysis – Predictive Analytics](https://github.com/tejgokhale/portfolio/tree/main/rfm_model)
Our fundraising team needed more information about our digital donors to make savvier decisions about when and how to ask small dollar donors for donations. The project was involved, first compiling multiple sources of as much wealth and consumer information on our donors, before grouping them using clustering with the primary features as recency, frequency, monetary value of donations. The model itself was deployed into production and as new donors were added to our database, they were categorized into the existing clusters. The fundraising team made messaging decisions based on this model, which increased revenue from these donors as much as 20% between months. Built in 2020/2021. The code here cannot be run, but is demonstrative of the work product. 

## [Membership – Data Visualization](https://github.com/tejgokhale/portfolio/tree/main/membership_visualization)
MFOL is a membership organization, mobilizing young people across the country in pursuit of ending gun violence. As the first data director, one of my first priorities was preparing reports for our leadership team on the size & scale of our network to recommend a new membership strategy. Using Folium & PyWaffle, I built visualizations that were easy to comprehend and demonstrated the main issue for leadership to solve – how we could focus our efforts on both an on the ground chapter network and engaging a broader network of supporters that did not live near a chapter. Ultimately, these visualizations convinced leadership to invest more in digital infrastructure to engage the broader network of supporters of our movement to end gun violence -- increasing the efficacy of our tactics. Built in 2021. The code can be run with the sample data. The data here is, of course, not the full dataset and only a sample to demonstrate the code.  

## [SQL – Dashboard Building](https://github.com/tejgokhale/portfolio/tree/main/sql)
Most of my dashboard building has been in Looker and Periscope. These are just some of the queries that I had to write to get things in a readable state for nontechnical stakeholders. “Acquisition pacing” shows acquisition of new members from the start of the month to now, which was helpful for the marketing team to understand how a current month’s performance is pacing compared to where they were last month at the same time. “Donations” was written to build a graph showing donations of users depending on when (before or after 2021) they first donated and layering the two onto the same graph for comparison of the value of existing versus new donors. Finally, “SMS segments” was a composite table built out of many pieces of information about SMS users to easily query one table of SMS user activity that the marketing team could build segments off of. All of these code snippets sat on dashboards that nontechnical stakeholders used everyday to make data-informed decisions about their strategy. Built in 2022. The code here cannot be run, but is demonstrative of the work product. 

## [Aid & Alliance – Index-Building](https://github.com/tejgokhale/aid-alliance/tree/main/index)
Aid & Alliance is a flagship mutual aid and resource sharing program designed to distribute nearly $500,000 in mutual aid funds to BIPOC organizers and activists across the country. When designing the cities track, we knew that we needed to limit the number of cities that we open the program to 8. This was both an impact and a capacity decision -- with limited funds, we wanted to make sure that the size of the grants were useful to organizations and we wanted to ensure that we had the people power to manage distribution, process, and reporting. In order to select the cities in which we open the program to, I designed a custom index based on stakeholder input to rank cities across the country and give decision makers a stronger sense of ordinality of need. The final decision on which cities to include was made using the insights from this index. Built in 2021. The code can be run with the full data files (publicly available).

## [Chi Square – Statistical Analysis](https://github.com/tejgokhale/portfolio/tree/main/chi_square)
This is a snippet of code from a project I had to do around survey analysis – running a chi-square test of independence to see if there’s an association between two categorical variables. Built in 2022. The code can be run with the sample data.
