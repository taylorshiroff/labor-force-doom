# men vs women flows out of the labor force

pacman::p_load(usethis,pacman,rio,ggplot2,ggthemes,quantmod,dplyr,data.table,lubridate,forecast,gifski,av,tidyr,gganimate,zoo,RCurl,Cairo,datetime,stringr,pollster,tidyquant,hrbrthemes,plotly,fredr)

data <- read.csv("https://raw.githubusercontent.com/taylorshiroff/labor-force-doom/main/data/genderflows.csv")

theme_apricitas <- theme_ft_rc() +
  theme(axis.line = element_line(colour = "white"),legend.position = c(.90,.90),legend.text = element_text(size = 14, color = "white"), plot.title = element_text(size = 28, color = "white")) #using the FT theme and white axis lines for a "theme_apricitas"

apricitas_logo <- image_read("https://github.com/Miles-byte/Apricitas/blob/main/Logo.png?raw=true") # downloading and rasterizing Apricitas Logo from github
apricitas_logo_rast <- rasterGrob(apricitas_logo, interpolate=TRUE)

menvswomen <- ggplot() + #plotting PCEPI growth
  geom_line(data=data, aes(x=as.Date(date),y=men, color= "Male flows out of the labor force"), size = 1.25)+ 
  geom_line(data=data, aes(x=as.Date(date),y=women,color= "Female flows out of the labor force"), size = 1.25)+  
  xlab("Date") +
  ylab("Thousands") +
  scale_y_continuous(limits = c(1500,5200), expand = c(0,0)) +
  scale_x_date(limits = c(as.Date("2020-01-01"),as.Date("2021-10-01")),date_breaks = "2 months", date_labels = "%m-%Y") +
  ggtitle("More Women Drop Out of the Labor Force Than Men When School Starts") +
  labs(caption = "Graph created by @JosephPolitano using BLS data") +
 # theme_apricitas + 
  theme(legend.position = c(.75,.6)) +
  scale_color_manual(name= NULL,values = c("#FFE98F","#00A99D","#EE6055","#A7ACD9")) +
 # annotation_custom(apricitas_logo_rast, xmin = as.Date("2019-12-01")-(.1861*639), xmax = as.Date("2019-12-01")-(0.049*639), ymin = 2000-(.3*3700), ymax = 2000) +
  coord_cartesian(clip = "off")

ggsave(dpi = "retina",plot = menvswomen, "menvswomen.png", type = "cairo-png") #CAIRO GETS RID OF THE ANTI ALIASING ISSUE

p_unload(all)  # Remove all add-ons

# Clear console
cat("\014")  # ctrl+L

rm(list = ls())

dev.off()
