> **Important:** This is a template repository to help you set up your team project.  
>  
> You are free to modify it based on your needs. For example, if your data is downloaded using *multiple* scripts instead of a single one (as shown in `\data\`), structure the code accordingly. The same applies to all other starter files—adapt or remove them as needed.  
>  
> Feel free to delete this text.


# The influence of movie duration on audience raitings, controling for release year
*Describe the purpose of this project* 

## Motivation

In evaluating audience reception of films, factors such as actor performance, genre, and budget have been extensively studied as significant predictors of individual ratings (Wallace et al., 1993).
*Provide background/motivation for your project*

**Mention your research question**

## Data
In this study, we use publicly available IMDb datasets: title.basics, containing metadata about movie titles (including release year and duration), and title.ratings, containing aggregate user ratings. The datasets are retrieved in TSV format from the IMDb website and merged using tconst. From the original set of variables, we focus on three that are relevant to our research question: movie duration (runtime_minutes), IMDb user rating (average_rating), and release year (start_year).
After merging, cleaning, and aggregating, the datasets consists of 301,411 observations. This reduction in the number of observations is due to the process of merging and cleaning the data. In particular, missing values were removed, films with unrealistic durations (0 minutes or longer than 300 minutes) were excluded, and films listed as released in 2026 (which probably do not yet have complete ratings) were omitted.
![Table 1. Operationalization of Variables](docs/images/Screenshot 2025-09-11 200218.png)


## Method

- What methods do you use to answer your research question?
- Provide justification for why it is the most suitable. 

## Preview of Findings 
- Describe the gist of your findings (save the details for the final paper!)
- How are the findings/end product of the project deployed?
- Explain the relevance of these findings/product. 

## Repository Overview 

**Include a tree diagram that illustrates the repository structure*

## Dependencies 

*Explain any tools or packages that need to be installed to run this workflow.*

## Running Instructions 

*Provide step-by-step instructions that have to be followed to run this workflow.*

## About 

This project is set up as part of the Master's course [Data Preparation & Workflow Management](https://dprep.hannesdatta.com/) at the [Department of Marketing](https://www.tilburguniversity.edu/about/schools/economics-and-management/organization/departments/marketing), [Tilburg University](https://www.tilburguniversity.edu/), the Netherlands.

The project is implemented by team < x > members: < insert member details>
