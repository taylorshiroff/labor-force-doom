# labor force participation

pacman::p_load(usethis,pacman,rio,ggplot2,ggthemes,quantmod,dplyr,data.table,lubridate,forecast,gifski,av,tidyr,gganimate,zoo,RCurl,Cairo,datetime,stringr,pollster,tidyquant,hrbrthemes,plotly,fredr)

data <- read.csv("https://raw.githubusercontent.com/taylorshiroff/labor-force-doom/main/data/all_prime.csv")

coeff <- 1.27

theme_apricitas <- theme_ft_rc() +
  theme(axis.line = element_line(colour = "white"),legend.position = c(.90,.90),legend.text = element_text(size = 14, color = "white"), plot.title = element_text(size = 28, color = "white")) #using the FT theme and white axis lines for a "theme_apricitas"

apricitas_logo <- image_read("https://github.com/Miles-byte/Apricitas/blob/main/Logo.png?raw=true") # downloading and rasterizing Apricitas Logo from github
apricitas_logo_rast <- rasterGrob(apricitas_logo, interpolate=TRUE)

all_prime <- ggplot() + #plotting PCEPI growth
  geom_line(data=data, aes(x=as.Date(date),y=all, color= "Headline labor force participation rate (left axis)"), size = 1.25)+ 
  geom_line(data=data, aes(x=as.Date(date),y=prime/coeff,color= "Prime age labor force participation rate (right axis)"), size = 1.25)+ 
  xlab("Date") +
  ylab("Percent") +
  scale_y_continuous(name = "Labor Force Participation Rate", limits = c(60,67), expand = c(0,0), sec.axis = sec_axis(~.*coeff, name = "Prime Age Participation Rate")) +
  scale_x_date(limits = c(as.Date("2008-01-01"),as.Date("2021-10-01")),date_breaks = "12 months", date_labels = "%Y") +
  ggtitle("Employment Recovered in Sectors Heavily Affected by the Great Recession") +
  labs(caption = "Graph created by @JosephPolitano using BLS data") +
  theme_apricitas + 
  theme(legend.position = c(.3,.2)) +
  scale_color_manual(name= NULL,values = c("#FFE98F","#00A99D","#EE6055","#A7ACD9")) +
  annotation_custom(apricitas_logo_rast, xmin = as.Date("2008-01-01")-(.1861*5022), xmax = as.Date("2008-01-01")-(0.049*5022), ymin = 60-(.3*7), ymax = 60) +
  coord_cartesian(clip = "off")

ggsave(dpi = "retina",plot = all_prime, "all_prime.png", type = "cairo-png") #CAIRO GETS RID OF THE ANTI ALIASING ISSUE

p_unload(all)  # Remove all add-ons

# Clear console
cat("\014")  # ctrl+L

rm(list = ls())

dev.off()
