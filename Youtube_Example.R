
#### Schritt 1: Aktivierung notwendiger Software-Pakete ####

library("tuber")
library("tidyverse")

#### Schritt 2: Login Youtube API via tuber ####
cred <- read.csv("Documents/cred.txt") #.txt Dokument mit API-Zugangsdaten
yt_oauth(cred$ID, cred$secret) 
rm(cred)

#### Schritt 3: Datendownload ####
channel_ID <- "UCknLrEdhRCp1aegoMqRaCZg"
video_stats <- get_channel_stats(channel_ID) 

##### 3.1 Liste relevanter Videos #####
video_list <- yt_search(term = "terror|terrorism|terrorist",
                        channel_id = channel_ID,
                        published_after = "2021-08-26T00:00:00Z", 
                        published_before = "2021-08-31T00:00:00Z")

 ##### 3.2 Popularitätsmetriken (Likes, Shares) zu relevanten Videos #####
videos_infos <- video_list$video_id %>% 
  map(function(x) get_stats(x)) %>%
  bind_rows(.id = "column_label") %>% 
  select(-column_label)
video_list <- merge(video_list, videos_infos, by.x = "video_id", by.y = "id")

 ##### 3.3 Popularitätsmetriken (Kommentare) zu relevanten Videos #####
 comments <- video_list$video_id %>% map(function(x) get_all_comments(x)) %>%
  bind_rows(.id = "column_label") %>% 
  select(-column_label) %>% 
  filter(is.na(parentId)==T)


