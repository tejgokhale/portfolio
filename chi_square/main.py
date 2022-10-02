import scipy.stats as stats

    """
    @Overview: Calculates chi-squared test statistics. 
    @Parameters: chi_data = dataframe
                 col = primary column name to run test off of
                 col1 = answer column name to run test off of
    @Global Variables: N/A
    @Local Variables: data_crosstab = crosstab created for chi-square test 
                      alpha = significance level desired for the test
    @Returns: chi_square = chi-square test statistic
              p_value = p_value of the test
              conclusion = whether the test failed or there is an association
    """
  
def chi_squared(chi_data, col, col1):
    data_crosstab = pd.crosstab(chi_data[col], chi_data[col1], margins=True, margins_name="Total")

    # Calculate chi-square test statistic
    chi = 0
    rows = chi_data[col].unique()
    columns = chi_data[col1].unique()
        
    for x in columns:
        for y in rows:
            o = data_crosstab[x][y]
            e = data_crosstab[x]['Total'] * data_crosstab['Total'][y] / data_crosstab['Total']['Total']
            chi += (o-e)**2/e

    # Calculate p-value and conclusion based on alpha
    alpha = 0.05
    p_value = 1 - stats.norm.cdf(chi, (len(rows)-1)*(len(columns)-1))
        
    conclusion = "Failed"
    if p_value <= alpha:
        conclusion = "Association"
    
    return chi, p_value, conclusion
  
  
import pandas as pd
import requests 
import io

url = "https://raw.githubusercontent.com/tejgokhale/portfolio/main/chi_square/data/sample_chi_data.csv"
data = requests.get(url).content

sample = pd.read_csv(io.StringIO(data.decode('utf-8')))

print(chi_squared(sample, 'race', 'q5'))
print(chi_squared(sample, 'race', 'q6'))
