source('./r_files/flatten_HTML.r')

############### Library Declarations ###############
libraryRequireInstall("ggplot2");
libraryRequireInstall("plotly");
libraryRequireInstall("dplyr");
libraryRequireInstall("lubridate");
libraryRequireInstall("reshape");
libraryRequireInstall("tidyverse");
libraryRequireInstall("tidyr");
libraryRequireInstall("ggthemes")

####################################################

################### Actual code ####################

dataset <- values

# Paste or type your script code here:

avg_rd2 <- dataset %>% as.data.table
avg_rd2$date_fix <- as.Date((substr(avg_rd2$Date, 1, 10)), format="%Y-%m-%d")
avg_rd2$dm <- floor_date(avg_rd2$date_fix, unit = 'month')
avg_rd2$Avg <- avg_rd2$'Room Duration'
avg_rd2$gr <- avg_rd2$'Room'

p1 <-  ggplot(avg_rd2, aes(x = dm, y = Avg, group = dm, fill = dm)) +
geom_boxplot() +
stat_summary(fun = "mean", geom = "point", shape = 8,
               size = 2, color = "white") +
  scale_x_date(date_breaks = "1 month", date_labels =  "%b-%y") +
  facet_grid(gr ~ .) +
  theme_grey()

#Tooltip for plotly
avg_rd2[,text:=paste0(
  dm, ', ',  Avg, '<br>'
)]


# Show project text
p <- p +  geom_text(aes(label = dm,
                        text=text,x=dm
                         ,y = text_position,colour=gr),
                     size = 3, family = 'sans',
                    show.legend = F)


####################################################

############# Create and save widget ###############
p = ggplotly(p1, tooltip = 'text') %>% 
layout(legend = list(
  orientation = 'h',
    y = 1.1,
    x = 0.15
  ),font = list(family= 'Segoe UI'));
internalSaveWidget(p, 'out.html');
####################################################

################ Reduce paddings ###################
ReadFullFileReplaceString('out.html', 'out.html', ',"padding":[0-9]*,', ',"padding":0,')
####################################################
