# Introduction
The purpose of this project is to examine whether and how movie length influences audience ratings, while controlling for release year. We test if longer films are consistently perceived as higher quality or if extended runtimes risk diminishing audience engagement. By focusing directly on runtime rather than treating it as a side factor, we aim to establish a clear relationship between film length and ratings. This allow us to identify whether there is an optimal duration for films and to understand how this relationship may have shifted over time.

## Motivation

In evaluating audience reception of films, factors such as actor performance, genre, and budget have been extensively studied as significant predictors of ratings (Wallace et al., 1993). Runtime, often included merely as a control variable in prior research, also carries meaningful implications for audience perception (Ashari et al., 2022). A longer duration often reflects higher production value and suggests a narrative depth that justifies viewers’ time investment. However, excessive runtime may adversely affect enjoyment due to reduced audience attention and potential fatigue. 

Empirical evidence on the relationship between movie duration and audience ratings remains inconclusive. Some studies identify a positive association, whereas others report a nonlinear or genre specific effect. To address this gap, the current study investigates the influence of movie duration on audience ratings. 

Given that rating behaviour and audience preferences evolve over time (Amendola et al., 2015), we incorporate release year as a control variable to enhance internal validity and account for temporal dynamics in consumer behaviour. 

**Research Question**

**To what extent does movie duration influence audience ratings, controlling for release year?**

## Data
In this study, we use publicly available IMDb datasets: title.basics, containing metadata about movie titles (including release year and duration), and title.ratings, containing aggregate user ratings. The datasets are retrieved in TSV format from the IMDb website and merged using tconst. From the original set of variables, we focus on three that are relevant to our research question: movie duration (runtime_minutes), IMDb user rating (average_rating), and release year (start_year). After cleaning, merging and deduplicating, the datasets consist of 345,777 observations. This reduction reflects filtering and merging steps: films with unrealistic durations (shorter than 40 minutes or longer than 300 minutes) were excluded, and 77 duplicates were resolved by keeping the title with the highest number of votes. The decision to include only movies longer than 40 minutes follows the AFI (American Film Institute) standards, which classify such works as feature films (Urbanora, 2010).

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

We estimated a series of Ordinary Least Squares (OLS) regressions to examine how runtime_minutes affects average_rating, controlling for start_year (release year).
OLS is suitable since the dependent variable, average_rating, is a continuous 0–10 score, and we are interested in the average marginal effect of runtime on IMDb ratings. The baseline linear model provides interpretable coefficients in rating points per additional runtime minute.
To ensure robustness and explore potential model improvements, we conducted additional testing through two model extensions. To perform our first check, we used Quadratic Specification, where we added a squared runtime term (runtime_minutes²) to test whether the relationship between runtime and rating is non-linear (e.g., whether ratings rise with runtime up to a point and then level off or decline). Secondly, we included the Interaction Model by introducing an interaction between runtime_minutes and start_year to test whether the effect of runtime varies across different release years, capturing potential time trends or changing audience preferences.
As the final step, we visualised and compared the predicted values and fitted lines to compare the linear and quadratic models and to illustrate how runtime influences predicted IMDb ratings over time. This combination of baseline and additional tests lets us assess linearity and potential time-varying effects without changing the core OLS framework.

## Preview of Findings 
*Gist of your findings* 
In the interaction model, runtime has a small but significant positive effect on IMDb ratings (b = 0.2475, p < .001), while the negative interaction with release year (b = –0.00012, p < .001) indicates that this relationship weakens for more recent films. The quadratic specification confirms a slight nonlinearity: very short and very long films tend to receive higher ratings, though the overall explanatory power remains modest (adjusted R² ≈ 0.017).

*How our findings are deployed:*
After cleaning and merging the dataset, we used regression outputs to visualize how runtime relates to audience ratings, controlling for release year. These visualizations can be extended with additional predictors such as genre or budget.

*Relevance of the findings:*
Longer films tend to receive slightly higher ratings, but this effect has weakened in recent years. This may indicate changing viewer habits and possibly less tolerance for longer film lengths.

## Repository Overview 

if (!requireNamespace("fs", quietly = TRUE)) install.packages("fs")

paths <- c(
  "reporting/", "src/", ".gitignore", "README.md", "makefile", ".RDataTmp",
  "reporting/Data_exploration.Rmd",
  "reporting/Deliverable 4_updated.Rmd",
  "reporting/Deliverables_updated.Rmd",
  "reporting/Final_Paper.Rmd",
  "reporting/Final_complete_analysis.Rmd",
  "reporting/Data_Exploration_Report.pdf",
  "src/analysis/", "src/data-preparation/",
  "src/analysis/Makefile",
  "src/analysis/data_analysis.R",
  "src/analysis/data_exploration.R",
  "src/analysis/lm_main_effect.R",
  "src/data-preparation/clean_data.R",
  "src/data-preparation/download_data.R",
  "src/data-preparation/filter_data.R",
  "src/data-preparation/merge_data.R",
  "src/data-preparation/setup.R"
)

fs::dir_create(paths[grepl("/$", paths)])
fs::file_create(setdiff(paths, paths[grepl("/$", paths)]))

tree_txt <- fs::dir_tree(
  path = ".", recurse = 3,
  regexp = "\\.git|\\.Rproj\\.user|renv|__pycache__|\\.DS_Store|\\.Rhistory|\\.RData|\\.RDataTmp|\\.pdf$",
  invert = TRUE
)

if (!file.exists("README.md")) fs::file_create("README.md")
cat("\n## Repository Overview\n\n```text\n",
    paste(tree_txt, collapse = "\n"),
    "\n```\n", file = "README.md", append = TRUE)

## Dependencies 

Please follow the installation guides on <http://tilburgsciencehub.com/>.

- R. [Installation guide](https://tilburgsciencehub.com/topics/computer-setup/software-installation/rstudio/r/).
- Make. [Installation guide](https://tilburgsciencehub.com/topics/automation/automation-tools/makefiles/make/).
- To knit RMarkdown documents, make sure you have installed Pandoc using the [installation guide](https://pandoc.org/installing.html) on their website.
- For R, make sure you have installed the following packages:

    ```text
    install.packages("data.table")
    install.packages("knitr")
    install.packages("kableExtra")
    install.packages("broom")
    install.packages("gt")
    install.packages("ggplot2")
    install.packages("dplyr")
    install.packages("tidyr")
    install.packages("tibble")
    install.packages("modelsummary")
    install.packages("sandwich")
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


## References
Amendola, L., Marra, V., & Quartin, M. (2015). The evolving perception of controversial movies. Palgrave Communications, 1(1). https://doi.org/10.1057/palcomms.2015.38 

Antipov, E. A., & Pokryshevskaya, E. B. (2016). How to measure the power of actors and film directors? Empirical Studies of the Arts, 34(2), 147–159. https://doi.org/10.1177/0276237416628904

Ashari, I. F., Banjarnahor, R., Farida, D. R., Aisyah, S. P., Dewi, A. P., & Humaya, N. (2022, 14 juli). Application of Data Mining with the K-Means Clustering Method and Davies Bouldin Index for Grouping IMDB Movies. Journal Of Applied Informatics And Computing. Geraadpleegd op 4 september 2025, van https://jurnal.polibatam.ac.id/index.php/JAIC/article/view/3485 

Choudhary, T., Chakraborty, T., Arun, D. P., Goyal, N., & Singla, S. (2024). Ratings and Factor Affecting Across Genres: A Study from Entertainment Industry. SSRN Electronic Journal. https://doi.org/10.2139/ssrn.4502176

Gupta, S., Adhikari, U., Varshney, S., & Choudhury, T. (2025). Computational analysis of genre effects on movie ratings using MLP algorithms. Journal of Computer Science, 21(4), 905–917. https://doi.org/10.3844/jcssp.2025.905.917

Kaimann, D., & Pannicke, J. (2015). Movie success in a genre specific contest: Evidence from the US film industry. https://hdl.handle.net/10419/142323

Liu, A. X., Liu, Y., & Mazumdar, T. (2013, August). Star Power in the Eye of the Beholder: A Study of the Influence of Stars in the Movie Industry. Marketing Letters, 1-12. SSRN. https://ssrn.com/abstract=2655797

Urbanora. (2010, September 19). AFI Catalog Silent Film database. The Bioscope. https://thebioscope.net/2010/09/19/afi-catalog-silent-film-database/

Wallace, W. T., Seigerman, A., & Holbrook, M. B. (1993). The role of actors and actresses in the success of films: how much is a movie star worth? Journal Of Cultural Economics, 17(1), 1–27. https://doi.org/10.1007/bf00820765 

Zhang, H. (2025). Analysis of business factors influencing film revenue. Advances in Economics Management and Political Sciences, 166(1), 1–7. https://doi.org/10.54254/2754-1169/2025.20876 