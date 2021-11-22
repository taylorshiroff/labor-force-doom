# relative employment levels by age/gender

pacman::p_load(usethis,pacman,rio,ggplot2,ggthemes,quantmod,dplyr,data.table,lubridate,forecast,gifski,av,tidyr,gganimate,zoo,RCurl,Cairo,datetime,stringr,pollster,tidyquant,hrbrthemes,plotly,fredr)

data <- read.csv("https://raw.githubusercontent.com/taylorshiroff/labor-force-doom/main/data/ageshare.csv")

theme_apricitas <- theme_ft_rc() +
  theme(axis.line = element_line(colour = "white"),legend.position = c(.90,.90),legend.text = element_text(size = 14, color = "white"), plot.title = element_text(size = 28, color = "white")) #using the FT theme and white axis lines for a "theme_apricitas"

apricitas_logo <- image_read("https://github.com/Miles-byte/Apricitas/blob/main/Logo.png?raw=true") # downloading and rasterizing Apricitas Logo from github
apricitas_logo_rast <- rasterGrob(apricitas_logo, interpolate=TRUE)

relativeage <- ggplot() + #plotting PCEPI growth
  geom_line(data=data, aes(x=as.Date(date),y=data$X100_men,color= "Younger than 65: Male Employment"), size = 1.25)+ 
  geom_line(data=data, aes(x=as.Date(date),y=data$X100_women,color= "Younger than 65: Female Employment"), size = 1.25)+ 
  geom_line(data=data, aes(x=as.Date(date),y=data$X100_boomer,color= "Over 65: Male and Female Employment"), size = 1.25)+ 
  xlab("Date") +
  ylab("100 = February 2020") +
  scale_y_continuous(limits = c(78,102), expand = c(0,0)) +
  scale_x_date(limits = c(as.Date("2020-02-01"),as.Date("2021-10-01")),date_breaks = "3 months", date_labels = "%m-%Y") +
  ggtitle("Flows Out of the Labor Force Move With School") +
  labs(caption = "Graph created by @JosephPolitano using BLS data") +
  theme_apricitas + 
  theme(legend.position = c(.7,.3)) +
  scale_color_manual(name= NULL,values = c("#FFE98F","#00A99D","#EE6055","#A7ACD9")) +
  annotation_custom(apricitas_logo_rast, xmin = as.Date("2019-12-01")-(.1861*608), xmax = as.Date("2019-12-01")-(0.049*608), ymin = 78-(.3*24), ymax = 78) +
  coord_cartesian(clip = "off")

ggsave(dpi = "retina",plot = relativeage, "relativeage.png", type = "cairo-png") #CAIRO GETS RID OF THE ANTI ALIASING ISSUE

p_unload(all)  # Remove all add-ons

# Clear console
cat("\014")  # ctrl+L

rm(list = ls())

dev.off()
