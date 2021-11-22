# flows from unemployment 

pacman::p_load(usethis,pacman,rio,ggplot2,ggthemes,quantmod,dplyr,data.table,lubridate,forecast,gifski,av,tidyr,gganimate,zoo,RCurl,Cairo,datetime,stringr,pollster,tidyquant,hrbrthemes,plotly,fredr)

flows <- read.csv("https://raw.githubusercontent.com/taylorshiroff/labor-force-doom/main/data/flows.csv")

theme_apricitas <- theme_ft_rc() +
  theme(axis.line = element_line(colour = "white"),legend.position = c(.90,.90),legend.text = element_text(size = 14, color = "white"), plot.title = element_text(size = 28, color = "white")) #using the FT theme and white axis lines for a "theme_apricitas"

apricitas_logo <- image_read("https://github.com/Miles-byte/Apricitas/blob/main/Logo.png?raw=true") # downloading and rasterizing Apricitas Logo from github
apricitas_logo_rast <- rasterGrob(apricitas_logo, interpolate=TRUE)

flows2 <- flows %>%
dplyr::select(date, p_uu, p_ue, p_unilf) %>% 
gather(key = "variable", value = "value", -date)

flows_chart <- ggplot(flows2, aes(x=as.Date(date), y=value, fill=variable)) + #plotting PCEPI growth
  geom_area(alpha=0.85 , size=.5, colour="#ededed") + 
  xlab("Date") +
  ylab("Percent") +
  scale_y_continuous(limits = c(0,100.1), expand = c(0,0)) +
  scale_x_date(limits = c(as.Date("2019-01-01"),as.Date("2021-10-01")),date_breaks = "4 months", date_labels = "%m-%Y") +
  ggtitle("Flows From Unemployment: Fewer Unemployed Are Finding Work") +
  labs(caption = "Graph created by @JosephPolitano using BLS data") +
  theme_apricitas + 
  theme(legend.position = c(.3,.25)) +
  scale_fill_manual(name= NULL,values = c("#FFE98F","#00A99D","#EE6055","#A7ACD9"), labels = c("Percent of unemployed who became employed", "Percent of unemployed who remained unemployed", "Percent of unemployed who left the labor force")) +
  annotation_custom(apricitas_logo_rast, xmin = as.Date("2019-01-01")-(.1861*1004), xmax = as.Date("2019-01-01")-(0.049*1004), ymin = 0-(.3*100.1), ymax = 0) +
  coord_cartesian(clip = "off")

ggsave(dpi = "retina",plot = flows_chart, "flows.png", type = "cairo-png") #CAIRO GETS RID OF THE ANTI ALIASING ISSUE

p_unload(all)  # Remove all add-ons

# Clear console
cat("\014")  # ctrl+L

rm(list = ls())

dev.off()
