
library(xml2)
library(readr)
library(plyr)
library(dplyr)

# Pyotr https://docs.google.com/document/d/1eOt2G7t8sYCHnXJ7yJvCG9hC-zsFyF24UKGrYSCGA0E/export?format=html
# Oleg https://docs.google.com/document/d/1LDVrFa-KY96r2ansScxWAYCtqq7bJLSAWM9y4kKcnWI/export?format=html
# Darja https://docs.google.com/document/d/1meTvtRdlUoe7t_ms2WVpdPV6HM6yA6_Kf3P-wKeCC7o/export?format=html

# https://docs.google.com/document/d/1ZXNK4IlFe9lPsgxe4Yj2UHgkby6oQagOUJVxNP0OCPs/export?format=html

# komi_example <- "https://docs.google.com/document/d/1LDVrFa-KY96r2ansScxWAYCtqq7bJLSAWM9y4kKcnWI/export?format=html"

corpus <- c("1eOt2G7t8sYCHnXJ7yJvCG9hC-zsFyF24UKGrYSCGA0E", # Pyotr
            "1meTvtRdlUoe7t_ms2WVpdPV6HM6yA6_Kf3P-wKeCC7o", # Darya
            "1NY7sF0fD-CLGh_tqxklNQP2ttz2WwOS5MlMyHtXKMnc", # Tsypanov
            "1SHZnX6ZFj7njYW4v0AuWSWGuqOCNwZTsiIG3ULCJEDs", # zbk 1985
            "1HDwbl5RjBKeEg8gCEyXxVrgS487UPn8478sU2kvVStc", # zbk 1980
            "1bOqOawnzlst48lwpa4n_PUFP4It6oAUJN2Xu6okCJqM", # furor
            "1LDVrFa-KY96r2ansScxWAYCtqq7bJLSAWM9y4kKcnWI", # oleg
            "1FzzW4L44sI6mF6uczNCy7wFqWNy6OlKsShXybVZLHdk", # ib 2005
            "1LnSeJSCesRiLifOMyZYkAII3LzHXJZc-hj2FcYWrkKA") # kpv_four_battles 

actors <- c("Pyotr", "Darya", "Tsypanov", "zbk1985", "zbk1980", "furor", "oleg", "ib2005", "four_battles")

library(httr)

fetch_gdoc <- function(doc_id = "1FzzW4L44sI6mF6uczNCy7wFqWNy6OlKsShXybVZLHdk"){
        current_document <- GET(paste0("https://docs.google.com/feeds/download/documents/export/Export?id=", doc_id,"&exportFormat=html"))
        content(current_document, "text")
}

data_list <- plyr::llply(corpus, fetch_gdoc)

# readr::write_file(data_list[[1]], "docs/example.html")

read_gdocs_html <- function(html_file){
        
        test_xml <- xml2::read_html(html_file) %>% xml2::xml_find_all("//p/span")
        
        result_text <- plyr::ldply(test_xml, function(x){
                dplyr::data_frame(style = x %>% xml2::xml_attr("class"),
                                  text = x %>% xml2::xml_text())
        })}

gdocs_df_list <- plyr::llply(data_list, read_gdocs_html)

library(stringr)

parse_css <- function(x){
        x %>% read_html() %>% 
                xml_find_all("//style") %>% 
                xml_text() %>% 
                str_split("\\.") %>% unlist() %>% str_subset(paste0("^c.+")) -> css_strings
        
        data_frame(css_value = str_replace(css_strings, "^(c\\d).+", "\\1"),
                   underline = str_detect(css_strings, "text-decoration:underline"),
                   bold = str_detect(css_strings, "font-weight:700"),
                   cursive = str_detect(css_strings, "font-style:italic")) %>%
                mutate(type = ifelse(bold == T & cursive == F, 
                                     yes = "rus_orig", 
                                     ifelse(underline == T & cursive == T, 
                                            yes = "rus_morph", "kpv"))) %>%
                select(css_value, type)
}


matched_lists <- Map(c, gdocs_df_list, as.list(actors), llply(data_list, parse_css))

ldply(matched_lists, function(x){
        data_frame(style = x$style,
                   text = x$text,
                   text_name = x[[3]]) %>% left_join(data_frame(text_name = x[[3]],
                                                                style = x$css_value,
                                                                type = x$type))
}) %>% tbl_df() -> cs_corpus

# cs_corpus %>% filter(text_name == "zbk1980")

cs_corpus %>% mutate(type = ifelse(is.na(type), "kpv", type)) -> cs


library(stringr)

# result_text %>% tidytext::unnest_tokens(output = "token", input = text) %>% View

cs %>% tidytext::unnest_tokens(output = "token", input = text) -> cs

left_join(cs, data_frame(text_name = actors,
                         mode = c("spoken", "spoken", "written", "written", "written", "written", "spoken", "written", "written"),
                         genre = c("interview", "interview", "scientific", "folklore", "folklore", "legal", "interview", "prose", "prose"),
                         formality = c(8, 8, 2, 3, 3, 2, 8, 5, 5)
)
) -> cs



cs %>% group_by(text_name) %>% mutate(lang = ifelse(type != "kpv", "rus", "no")) 
