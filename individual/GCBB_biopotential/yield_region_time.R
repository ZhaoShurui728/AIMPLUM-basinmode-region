

rg <- rgdx.set("../../..\\prog\\data\\data_prep.gdx", symName = 'MAP_RG') %>%
  mutate(R=as.character(R), G=as.numeric(as.character(G))) %>%
  mutate(RG=ifelse(R %in% c('USA','CAN','JPN','XE25','XOC', 'TUR', 'XER'), 'OECD', R))


yield2010 <- rgdx.param("../../..\\output\\gdx\\SSP2_base_BaU_NoCC\\bio\\2010.gdx", symName = 'YIELDBIO') %>%
  mutate(G=as.numeric(as.character(G))) %>%
  merge(rg %>% dplyr::select(G, RG), by = 'G', all.x = T)

yield2020 <- rgdx.param("../../..\\output\\gdx\\SSP2_base_BaU_NoCC\\bio\\2020.gdx", symName = 'YIELDBIO')%>%
  mutate(G=as.numeric(as.character(G))) %>%
  merge(rg %>% dplyr::select(G, RG), by = 'G', all.x = T)

yield2030 <- rgdx.param("../../..\\output\\gdx\\SSP2_base_BaU_NoCC\\bio\\2030.gdx", symName = 'YIELDBIO')%>%
  mutate(G=as.numeric(as.character(G))) %>%
  merge(rg %>% dplyr::select(G, RG), by = 'G', all.x = T)

yield2040 <- rgdx.param("../../..\\output\\gdx\\SSP2_base_BaU_NoCC\\bio\\2040.gdx", symName = 'YIELDBIO')%>%
  mutate(G=as.numeric(as.character(G))) %>%
  merge(rg %>% dplyr::select(G, RG), by = 'G', all.x = T)

yield2050 <- rgdx.param("../../..\\output\\gdx\\SSP2_base_BaU_NoCC\\bio\\2050.gdx", symName = 'YIELDBIO')%>%
  mutate(G=as.numeric(as.character(G))) %>%
  merge(rg %>% dplyr::select(G, RG), by = 'G', all.x = T)

yield2060 <- rgdx.param("../../..\\output\\gdx\\SSP2_base_BaU_NoCC\\bio\\2060.gdx", symName = 'YIELDBIO')%>%
  mutate(G=as.numeric(as.character(G))) %>%
  merge(rg %>% dplyr::select(G, RG), by = 'G', all.x = T)

yield2070 <- rgdx.param("../../..\\output\\gdx\\SSP2_base_BaU_NoCC\\bio\\2070.gdx", symName = 'YIELDBIO')%>%
  mutate(G=as.numeric(as.character(G))) %>%
  merge(rg %>% dplyr::select(G, RG), by = 'G', all.x = T)

yield2080 <- rgdx.param("../../..\\output\\gdx\\SSP2_base_BaU_NoCC\\bio\\2080.gdx", symName = 'YIELDBIO')%>%
  mutate(G=as.numeric(as.character(G))) %>%
  merge(rg %>% dplyr::select(G, RG), by = 'G', all.x = T)

yield2090 <- rgdx.param("../../..\\output\\gdx\\SSP2_base_BaU_NoCC\\bio\\2090.gdx", symName = 'YIELDBIO')%>%
  mutate(G=as.numeric(as.character(G))) %>%
  merge(rg %>% dplyr::select(G, RG), by = 'G', all.x = T)

yield2100 <- rgdx.param("../../..\\output\\gdx\\SSP2_base_BaU_NoCC\\bio\\2100.gdx", symName = 'YIELDBIO')%>%
  mutate(G=as.numeric(as.character(G))) %>%
  merge(rg %>% dplyr::select(G, RG), by = 'G', all.x = T)


yield_all = bind_rows(y2010=yield2010, y2020=yield2020, y2030=yield2030, y2040=yield2040, y2050=yield2050, 
                       y2060=yield2060, y2070=yield2070, y2080=yield2080, y2090=yield2090, y2100=yield2100, .id='Y') %>%
  mutate(Y=as.numeric(substr(Y,2,5))) %>%
  group_by(RG, Y) %>%
  summarise(yield_avg = mean(YIELDBIO) * 2) ## should check if needs to multiply by 2


reg <- (c("BRA","XLM", "XAF", "OECD", "XSE",
                "IND", "CHN", "XME", "XSA",
                "CIS","XNF"))

reg_lab_yield <- c('Brazil', 'Rest of South America', 'Rest of Africa','OECD',
             'Southeast Asia', 'India', 'China', 'Middle East', 'Rest of Asia',
             'Former Soviet Union', 'North Africa')


library(directlabels)

vv=brewer.pal(11, "Paired")

colvecadj = c(vv[1],vv[10],vv[8],vv[7],vv[11],vv[4],
              vv[2],vv[5],vv[8],vv[3],vv[6])

pyd<- ggplot(yield_all %>% 
               filter(Y<=2050) %>%
               merge(data.frame(RG=reg, RGfull = reg_lab_yield), by='RG', all.x=T), 
           aes(x=Y, y=yield_avg, linetype=RGfull,color=RGfull, label=RGfull)) +
  geom_line() +
  theme_minimal()+
  scale_linetype_discrete(breaks= reg_lab_yield,
                          name='Region')+
  scale_color_manual(breaks = reg_lab_yield,
                     name='Region',
                     values = colvecadj)+
  scale_x_continuous(breaks = seq(2010,2050,10), labels = seq(2010,2050,10), limits = c(2010,2050))+
  xlab('Year') + ylab('Bioenergy crop yield (tonne/ha/yr)')+
  theme(axis.text.y=element_text(color = 'grey30', hjust = 0),
        legend.key.width = unit(1,"cm"),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.major.y = element_blank(),
        panel.grid.minor.y = element_blank(),
        legend.position = "right",
        plot.margin = margin(1,0.2, 0, 0, "cm")) +
  theme(axis.ticks=element_blank())+
  theme(panel.border = element_rect(colour = "black", fill=NA, size=0.5))
  
#  geom_dl(method=last.bumpup)
pyd


p<- ggplot(pca_all %>% 
             filter(Y<=2050) %>%
             merge(data.frame(RR=reg, RGfull = reg_lab_yield), by='RR', all.x=T) %>%
             mutate(meancost=meancost*1000000), 
           aes(x=Y, y=meancost, linetype=RGfull,color=RGfull, label=RGfull)) +
  geom_line() +
  theme_minimal()+
  scale_linetype_discrete(breaks= reg_lab_yield,
                          name='Region')+
  scale_color_manual(breaks = reg_lab_yield,
                     name='Region',
                     values = colvecadj)+
  scale_x_continuous(breaks = seq(2010,2050,10), labels = seq(2010,2050,10), limits = c(2010,2050))+
  xlab('Year') + ylab('Bioenergy production cost (US$/ha/yr)')+
  theme(axis.text.y=element_text(color = 'grey30', hjust = 0),
        legend.key.width = unit(1,"cm"),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.major.y = element_blank(),
        panel.grid.minor.y = element_blank(),
        legend.position = "right",
        plot.margin = margin(1, 0.2, 0, 0, "cm")) +
  theme(axis.ticks=element_blank())+
  theme(panel.border = element_rect(colour = "black", fill=NA, size=0.5))

costyield_cb <-ggarrange(pyd, p, nrow = 1, ncol = 2, common.legend = T, labels = c('(a)', '(b)'),
                         label.x = 0.5, label.y = 1, widths= c(1,1.035),
                         legend='bottom')


ggsave("../../../anal_output_r\\Figure S1. yield_cost.jpeg",
       device = 'jpeg', width = 12*0.6,height = 7*0.6, dpi = 600)

