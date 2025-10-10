# Introduction
The purpose of this project is to examine whether and how movie length influences audience ratings, while controlling for release year. We test if longer films are consistently perceived as higher quality or if extended runtimes risk diminishing audience engagement. By focusing directly on runtime rather than treating it as a side factor, we aim to establish a clear relationship between film length and ratings. This allow us to identify whether there is an optimal duration for films and to understand how this relationship may have shifted over time.

## Motivation

In evaluating audience reception of films, factors such as actor performance, genre, and budget have been extensively studied as significant predictors of ratings (Wallace et al., 1993). Runtime, often included merely as a control variable in prior research, also carries meaningful implications for audience perception (Ashari et al., 2022). A longer duration often reflects higher production value and suggests a narrative depth that justifies viewers’ time investment. However, excessive runtime may adversely affect enjoyment due to reduced audience attention and potential fatigue. 

Empirical evidence on the relationship between movie duration and audience ratings remains inconclusive. Some studies identify a positive association, whereas others report a nonlinear or genre specific effect. To address this gap, the current study investigates the influence of movie duration on audience ratings. 

Given that rating behaviour and audience preferences evolve over time (Amendola et al., 2015), we incorporate release year as a control variable to enhance internal validity and account for temporal dynamics in consumer behaviour. 

**Research Question**

**To what extent does movie duration influence audience ratings, controlling for release year?**

## Data
In this study, we use publicly available IMDb datasets: title.basics, containing metadata about movie titles (including release year and duration), and title.ratings, containing aggregate user ratings. The datasets are retrieved in TSV format from the IMDb website and merged using tconst. From the original set of variables, we focus on three that are relevant to our research question: movie duration (runtime_minutes), IMDb user rating (average_rating), and release year (start_year).
After merging, cleaning, and deduplicating, the datasets consist of 345,656 observations. This reduction reflects filtering and merging steps: missing values were removed, films with unrealistic durations (shorter than 40 minutes or longer than 300 minutes) were excluded, and duplicates were resolved by keeping the title with the highest number of votes.

Table 1: Variable Explanation  

|Variable       |Type    |Definition                                                        |Role                 |
|:--------------|:-------|:-----------------------------------------------------------------|:--------------------|
|runtimeMinutes |integer |Duration of the movie in minutes                                  |Independent variable |
|averageRating  |double  |Average IMDb user rating (0–10 scale, aggregated from user votes) |Dependent variable   |
|startYear      |integer |Year the movie was released                                       |Control variable     |

Table 2: Descriptive Statistics  

|Variable       |       N| Missing|        Mean|          SD|  Min|     Max|
|:--------------|-------:|-------:|-----------:|-----------:|----:|-------:|
|runtimeMinutes |  345777|       0|   92.645589|    24.90015|   41|     300|
|averageRating  |  345777|       0|    6.184049|     1.34776|    1|      10|
|startYear      |  345777|       0| 1997.303375|    25.15304| 1894|    2025|


## Method

We estimate a linear regression (OLS) of average_rating on runtime_minutes, including start_year as a control. OLS is appropriate because the outcome is a continuous 0–10 mean rating, and we seek the average marginal effect of runtime. With our large sample, OLS delivers stable, easily interpretable coefficients in rating points per minute; we use robust HC3 standard errors to correct for heteroskedasticity and additionally test a quadratic specification and a runtime × start_year interaction to capture possible non-linearity and time variation. The runtime coefficient (and, under interaction, the runtime plus interaction term) gives the expected change in rating for a one-minute increase holding other terms constant, which directly answers our research question.

## Preview of Findings 
*Gist of your findings* 
In the interaction model (average_rating ~ runtime_minutes * start_year), the runtime_minutes coefficient is 0.2475 (SE = 0.0070, p < 0.001) and the runtime_minutes × start_year coefficient is −0.0001231 (SE = 0.0000035, p < 0.001), indicating a positive association that weakens with later release years; start_year is 0.01310 (SE = 0.0003211, p < 0.001). Model fit: adjusted R² = 0.006543, N = 345,656, F-statistic = 759.8, p < 2.2e-16.

*How our findings/product are deployed:*
After cleaning the dataset we used the regression outputs to predict and visualize how runtime relates to audience reception, including plots of observed vs. fitted relationships and predicted ratings by runtime. This analysis can be replicated or extended by adding variables such as genre or budget, and the visualizations can be used directly by specialists and academics in reports and presentations.

*Relevance of the findings/product:*
Overall, the results show that longer runtimes are associated with slightly higher ratings, but the negative interaction with release year suggests the relationship is smaller for more recent films. Given the modest explanatory power and potential genre-specific dynamics not accounted for here, runtime should be viewed as one of several structural factors affecting audience satisfaction.

## Repository Overview 

**Include a tree diagram that illustrates the repository structure*

## Dependencies 

Please follow the installation guides on <http://tilburgsciencehub.com/>.

- R. [Installation guide](https://tilburgsciencehub.com/topics/computer-setup/software-installation/rstudio/r/).
- Make. [Installation guide](https://tilburgsciencehub.com/topics/automation/automation-tools/makefiles/make/).
- To knit RMarkdown documents, make sure you have installed Pandoc using the [installation guide](https://pandoc.org/installing.html) on their website.
- For R, make sure you have installed the following packages:

    ```text
    install.packages("data.table")
    install.packages("tidyverse")
    install.packages("readr")
    install.packages("lubridate")
    install.packages("knitr")
    install.packages("kableExtra")
    install.packages("broom")
    install.packages("gt")
    install.packages("ISOweek")
    install.packages("zoo")
    install.packages("janitor")
    install.packages("ggplot2")
    install.packages("dplyr")
    install.packages("tidyr")
    install.packages("tibble")
    install.packages("checkmate")
    install.packages("modelsummary")
    install.packages("sandwich")
    install.packages("lmtest")
    install.packages("ggeffects")
    ```
    

## Running Instructions 

Running The Code By Make

To run the code, follow these instructions:
1. Fork this repository
2. Open your command line/terminal and run the following code:
    ```bash
    git clone https://github.com/course-dprep/the-length-effect.git
    ```
3. Set your working directory to `the-length-effect` and run the following command:
    ```bash
    make
    ```
4. When make has successfully run all the code, it will generate a PDF with the presentation of our analysis.
5. To clean the data of all raw and unnecessary data files created during the pipeline, run the following code in the command line/terminal:
    ```bash
    make clean
    ```

## About 

This project is set up as part of the Master’s course [Data Preparation & Programming Skills](https://dprep-book.hannesdatta.com) at the [Department of Marketing](https://www.tilburguniversity.edu/about/schools/economics-and-management/organization/departments/marketing), [Tilburg University](https://www.tilburguniversity.edu), the Netherlands.

The project is implemented by team 4, consisting of the following members:

- [Agata Kopiczynska](https://github.com/AgataKopiczynska), e-mail: [a.kopiczynska@tilburguniversity.edu](mailto:a.kopiczynska@tilburguniversity.edu) 
- [Bilyana Mihova](https://github.com/bilyanamm), e-mail: [b.mihova@tilburguniversity.edu](mailto:b.mihova@tilburguniversity.edu) 
- [Jekaterina Rakute](https://github.com/raakute), e-mail: [j.rakute@tilburguniversity.edu](mailto:j.rakute@tilburguniversity.edu) 
- [Simona Borisova](https://github.com/borisova-simona), e-mail: [s.borisova@tilburguniversity.edu](mailto:s.borisova@tilburguniversity.edu)
- [Thomas van den Dungen](https://github.com/ThomasvandenDungen), e-mail: [t.e.n.vdndungen@tilburguniversity.edu](mailto:t.e.n.vdndungen@tilburguniversity.edu)


