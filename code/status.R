## unemployment + other types

pacman::p_load(usethis,pacman,rio,ggplot2,ggthemes,quantmod,dplyr,data.table,lubridate,forecast,gifski,av,tidyr,gganimate,zoo,RCurl,Cairo,datetime,stringr,pollster,tidyquant,hrbrthemes,plotly,fredr)

types <- read.csv("https://raw.githubusercontent.com/taylorshiroff/labor-force-doom/main/data/types.csv")

theme_apricitas <- theme_ft_rc() +
  theme(axis.line = element_line(colour = "white"),legend.position = c(.90,.90),legend.text = element_text(size = 14, color = "white"), plot.title = element_text(size = 28, color = "white")) #using the FT theme and white axis lines for a "theme_apricitas"

apricitas_logo <- image_read("https://github.com/Miles-byte/Apricitas/blob/main/Logo.png?raw=true") # downloading and rasterizing Apricitas Logo from github
apricitas_logo_rast <- rasterGrob(apricitas_logo, interpolate=TRUE)

types2 <- types %>%
dplyr::select(date, unemployed, searched, nosearch) %>% 
gather(key = "variable", value = "value", -date)

types_chart <- ggplot(types2, aes(x=as.Date(date), y=value, fill=variable)) + #plotting PCEPI growth
  geom_area(alpha=0.85 , size=.5, colour="#ededed") + 
  xlab("Date") +
  ylab("Thousands") +
  scale_y_continuous(limits = c(0,35000), expand = c(0,0)) +
  scale_x_date(limits = c(as.Date("2019-01-01"),as.Date("2021-10-01")),date_breaks = "4 months", date_labels = "%m-%Y") +
  ggtitle("Many Who Aren't In the Labor Force Want Work") +
  labs(caption = "Graph created by @JosephPolitano using BLS data") +
  #theme_apricitas + 
  theme(legend.position = c(.75,.85)) +
  scale_fill_manual(name= NULL,values = c("#FFE98F","#00A99D","#EE6055","#A7ACD9"), labels = c("Did not look for work in last year", "Looked for work in last year but not last month", "Unemployed: looked for work in last month")) +
  annotation_custom(apricitas_logo_rast, xmin = as.Date("2019-01-01")-(.1861*1004), xmax = as.Date("2019-01-01")-(0.049*1004), ymin = 0-(.3*35000), ymax = 0) +
  coord_cartesian(clip = "off")

ggsave(dpi = "retina",plot = types_chart, "status.png", type = "cairo-png") #CAIRO GETS RID OF THE ANTI ALIASING ISSUE


p_unload(all)  # Remove all add-ons

# Clear console
cat("\014")  # ctrl+L

rm(list = ls())

dev.off()
