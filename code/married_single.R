# married vs single employment

pacman::p_load(usethis,pacman,rio,ggplot2,ggthemes,quantmod,dplyr,data.table,lubridate,forecast,gifski,av,tidyr,gganimate,zoo,RCurl,Cairo,datetime,stringr,pollster,tidyquant,hrbrthemes,plotly,fredr)

data <- read.csv("https://raw.githubusercontent.com/taylorshiroff/labor-force-doom/main/data/married_vs_single.csv")

theme_apricitas <- theme_ft_rc() +
  theme(axis.line = element_line(colour = "white"),legend.position = c(.90,.90),legend.text = element_text(size = 14, color = "white"), plot.title = element_text(size = 28, color = "white")) #using the FT theme and white axis lines for a "theme_apricitas"

apricitas_logo <- image_read("https://github.com/Miles-byte/Apricitas/blob/main/Logo.png?raw=true") # downloading and rasterizing Apricitas Logo from github
apricitas_logo_rast <- rasterGrob(apricitas_logo, interpolate=TRUE)

married_single <- ggplot() + #plotting PCEPI growth
  geom_line(data=data, aes(x=as.Date(date),y=X100_m_men, color= "Married men"), size = 1.25)+ 
  geom_line(data=data, aes(x=as.Date(date),y=X100_m_women,color= "Married women"), size = 1.25)+ 
  geom_line(data=data, aes(x=as.Date(date),y=X100_s_men,color= "Single men"), size = 1.25)+ 
  geom_line(data=data, aes(x=as.Date(date),y=X100_s_women,color= "Single women"), size = 1.25)+ 
  xlab("Date") +
  ylab("100 = February 2020") +
  scale_y_continuous(limits = c(75,102), expand = c(0,0)) +
  scale_x_date(limits = c(as.Date("2020-02-01"),as.Date("2021-10-01")),date_breaks = "3 months", date_labels = "%m-%Y") +
  ggtitle("Married Men and Women Have Regained Employment Slower Than Singles") +
  labs(caption = "Graph created by @JosephPolitano using BLS data") +
  theme_apricitas + 
  theme(legend.position = c(.7,.35)) +
  scale_color_manual(name= NULL,values = c("#FFE98F","#00A99D","#EE6055","#A7ACD9")) +
  annotation_custom(apricitas_logo_rast, xmin = as.Date("2020-02-01")-(.1861*608), xmax = as.Date("2020-02-01")-(0.049*608), ymin = 75-(.3*27), ymax = 75) +
  coord_cartesian(clip = "off")

ggsave(dpi = "retina",plot = married_single, "married_single", type = "cairo-png") #CAIRO GETS RID OF THE ANTI ALIASING ISSUE

p_unload(all)  # Remove all add-ons

# Clear console
cat("\014")  # ctrl+L

rm(list = ls())

dev.off()
