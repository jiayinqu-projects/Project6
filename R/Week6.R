#R Studio API Code
library(rstudioapi)
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

#Data Import
library(stringi)
citations <- stri_read_lines("../data/citations.txt")
citations_txt <- citations[stri_isempty(citations) == FALSE]
length(citations) - length(citations_txt)

#Data Cleaning
library(stringr)
library(tidyverse)
library(magrittr)
sample(citations_txt, 10)
citations_tbl <- tibble(line = 1:length(citations_txt), cite = citations_txt) %>%
  mutate(cite = str_replace_all(cite, c("\"" = "", "\'" = "")))  %>% 
  mutate(year = gsub("[\\(\\)]", "", str_extract(cite, "\\(?(18|19|20)[:digit:]{2}\\.?\\)?"))) %>%
  mutate(page_start = gsub("([-?]\\d+)|(\\d*\\s)", "", str_extract(cite, "(?![^\\(\\d*\\)]*\\))(\\d+[-?]\\d+)|(\\s\\d\\d?\\d?\\s\\d+)"))) %>%
  mutate(perf_ref = str_detect(cite, fixed("performance", ignore_case = TRUE))) %>%
  mutate(title = gsub("\\d+\\,?[a-z]?([.),\\s]+)?", "", str_extract(cite, "\\d{4}\\,?[a-z]?[\\s\\.\\,\\)]+?[A-Z][a-z][a-zA-Z\\s\\,\\?\\-\\/\\:\\&]{22,}[\\.\\?]"))) %>%
  mutate(cite = str_replace_all(cite, "<U+FEED>", ""))  %>% 
  mutate(first_author = str_extract(cite, "(\\*|[:alpha:]|\\-|\\s)+[\\,\\s]?([A-Z\\.\\,\\s]+)?([A-Z\\.\\,\\s]+)?([A-Z][\\.\\,\\s]+)"))

