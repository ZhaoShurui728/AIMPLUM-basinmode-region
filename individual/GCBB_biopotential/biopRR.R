library(gdxrrw)
library(dplyr)
library(reshape2)
library(qdap)
library(stacomirtools)
library(dplyr)
library(reshape2)
library(tibble)
library(directlabels)
library(ggplot2)
library(ggpubr)
library(gganimate)
library(forcats)

dir.create('../../../anal_output_r')


RG <- rgdx.set("..\\..\\data\\data_prep.gdx", symName = 'MAP_RG') %>% 
  mutate(R=as.character(R), G=as.numeric(as.character(G)))

bioe_in <- function(scenario){
  dfin <- NULL
    for (i in seq(2010, 2100, 10)) {
      dir <- paste('..\\..\\..\\output\\gdx\\', scenario, '_BaU_NoCC\\_bio\\',i,'.gdx', sep='')
      temp <- rgdx.param(dir, symName = 'PBIOSUP') %>%
        dcast(G+LB~.k) %>%
        mutate(Y=i, G=as.numeric(as.character(G)), LB = as.character(LB))
      dfin <- rbind(dfin, temp)
    }
  dfout <- merge(dfin, RG, by='G', all.x=T)
  return(dfout)
}

bioe_pric <-function(df){
  df_m <- df %>%
    group_by(Y,R) %>%
    arrange(Y, R, price) %>%
    do(mutate(.,r_sup = cumsum(.$quantity))) %>%
    ungroup()%>%
    group_by(Y)%>%
    arrange(Y,price)%>%
    do(mutate(.,w_sup = cumsum(.$quantity))) %>%
    ungroup()%>%
    group_by(Y) %>%
    mutate(perc = w_sup/max(w_sup)) %>%
    ungroup() %>%
    group_by(Y, R) %>%
    mutate(perc_r = r_sup/max(r_sup)) %>%
    ungroup()%>%
    group_by(Y)%>%
    arrange(desc(yield))%>%
    do(mutate(.,area_cum = cumsum(.$area))) %>%
    ungroup()
  return(df_m)
}

base <- bioe_in('SSP2_base') %>% bioe_pric()
soil1 <- bioe_in('SSP2_soil1') %>% bioe_pric()
soil2 <- bioe_in('SSP2_soil2') %>% bioe_pric()
biod1 <- bioe_in('SSP2_biod1') %>% bioe_pric()


## biodiversity protection index level

biod_level = 'ohashiSet95'

#### biod2 and full policy should exclude ohashi
ohashi <- rgdx.set("..\\..\\data\\Ohashi_biodiv.gdx", symName = biod_level) %>%
  mutate(i=as.numeric(as.character(i))) %>%
  pull(i)

biod2 <- biod1 %>%
  filter(!G %in% ohashi) %>% bioe_pric()

all <- bioe_in('SSP2_all') %>% 
  filter(!G %in% ohashi) %>%
  bioe_pric()
# sicio measure scenarios should also exclude biod region

demand <- bioe_in('SSP2_soci_dem')%>%
  filter(!G %in% ohashi) %>% bioe_pric()


supply <- bioe_in('SSP2_soci_sup')%>%
  filter(!G %in% ohashi) %>% bioe_pric()


supdem <- bioe_in('SSP2_soci_supdem')%>%
  filter(!G %in% ohashi) %>% bioe_pric()


SSP_ALL <- bind_rows(base = base, soil1 = soil1, soil2 = soil2, biod1 = biod1, biod2 = biod2, all = all,
                     demand = demand, supply = supply, supdem = supdem,
                     .id = 'Scenario') %>%
  mutate(Scenario = factor(Scenario, levels = c('base', 'soil1', 'soil2', 'biod1', 'biod2', 'all', 
                                                'demand', 'supply', 'supdem')))




SSP_POT_W <- SSP_ALL %>%
  group_by(Scenario,Y) %>%
  summarise(pot_w = max(w_sup))%>%
  ungroup()%>%
  group_by(Y)%>%
  mutate(perc = pot_w/max(pot_w))%>%
  ungroup()

SSP_POT_R_OECD <- SSP_ALL %>%
  mutate(RG=ifelse(R %in% c('USA','CAN','JPN','XE25','XOC', 'TUR', 'XER'), 'OECD', R)) %>%
  group_by(Scenario,Y,RG) %>%
  summarise(pot_r = sum(quantity)) %>%
  ungroup()%>%
  group_by(Y,RG)%>%
  mutate(perc=pot_r/max(pot_r))%>%
  ungroup()


SSP_ARE_R_OECD <- SSP_ALL %>%
  mutate(RG=ifelse(R %in% c('USA','CAN','JPN','XE25','XOC', 'TUR', 'XER'), 'OECD', R)) %>%
  group_by(Scenario,Y,RG) %>%
  summarise(are_r = sum(area)) %>%
  ungroup()%>%
  group_by(Y,RG)%>%
  mutate(perc=are_r/max(are_r))%>%
  ungroup()


bks <- c('base', 'soil1', 'soil2', 'biod1', 'biod2', 'all', 
         'demand', 'supply', 'supdem')

lbs <- c("No policy                                           ", 
         "Moderate soil protection",
         "Enhanced soil protection",
         "Moderate biodiversity protection     ", 
         "Enhanced biodiversity protection     ",
         "Full environmental policy",
         "Demand-side policy", 
         "Supply-side policy", 
         "Demand- and supply-side policy      ")

tabs <- c(" ",
          "Environmental policy",
          "Environmental policy",
          "Environmental policy",
          "Environmental policy",
          "Environmental policy",
          'Societal transformation',
          'Societal transformation',
          'Societal transformation')

########################################
##                                    ##
##       Global potential plot        ##
##                                    ##
########################################


color_vector <- get_palette('Dark2', 9)
col <- get_palette("jco", 5)

# 2050
glo_comp1 <- ggplot(SSP_POT_W %>% 
                      filter(Y %in% c(2050)) %>%
                      mutate(Y=factor(Y, levels = c(2050)))%>%
                      mutate(Scenario=factor(Scenario, levels = rev(bks)))%>%
                      ungroup() %>%
                      merge(data.frame(bks, tabs), by.x = 'Scenario', by.y='bks')%>%
                      filter(tabs==" "),
                    aes(x=Scenario, y = pot_w))+
  geom_segment(size = 2, aes(x = Scenario,y = pot_w,xend =Scenario,yend = 0,color=Scenario)) +
  coord_flip()+
  ylim(0,300)+
  scale_color_manual(values = rev(c(col[4])),
                     breaks = bks[1],
                     labels = lbs[1],
                     name = 'Environmental policy')+
  scale_x_discrete(breaks = bks[1],
                   labels = lbs[1])+
  geom_text(aes(label=paste(round(pot_w,0), "EJ", sep=' ')),
            position = position_dodge(0.8),hjust=-0.2,vjust=0.4,color='gray30', size=3)+
  theme_minimal() +
  ylab('Bioenergy potential (EJ)') +
  xlab('')+
  theme(axis.text.y=element_text(color = 'grey30', hjust = 0),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.major.y = element_blank(),
        panel.grid.minor.y = element_blank(),
        legend.position = "none",
        plot.margin = margin(0.2, 0.2, 0, 0, "cm")) +
  theme(axis.ticks=element_blank())+
  theme(panel.border = element_rect(colour = "black", fill=NA, size=0.5))+
  theme(axis.text.x = element_blank())+
  theme(axis.title.x = element_blank())


glo_comp2 <- ggplot(SSP_POT_W %>% 
                      filter(Y %in% c(2050)) %>%
                      mutate(Y=factor(Y, levels = c(2050)))%>%
                      mutate(Scenario=factor(Scenario, levels = rev(bks)))%>%
                      ungroup() %>%
                      merge(data.frame(bks, tabs), by.x = 'Scenario', by.y='bks') %>%
                      filter(tabs=="Environmental policy"),
                    aes(x=Scenario, y = pot_w))+
  geom_segment(size = 2, aes(x = Scenario,y = pot_w,xend =Scenario,yend = 0,color=Scenario)) +
  coord_flip()+
  ylim(0,300)+
  scale_color_manual(values = rev(rep(col[1],5)),
                     breaks = bks[2:6],
                     labels = lbs[2:6],
                     name = 'Environmental policy')+
  scale_x_discrete(breaks = bks[2:6],
                   labels = lbs[2:6])+
  geom_text(aes(label=paste(round(pot_w,0), "EJ", sep=' ')),
            position = position_dodge(0.8),hjust=-0.2,vjust=0.4,color='gray30', size=3)+
  theme_minimal() +
  ylab('Bioenergy potential (EJ)') +
  xlab('')+
  theme(axis.text.y=element_text(color = 'grey30', hjust = 0),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.major.y = element_blank(),
        panel.grid.minor.y = element_blank(),
        legend.position = "none",
        plot.margin = margin(0.2, 0.2, 0, 0, "cm")) +
  theme(axis.ticks=element_blank())+
  theme(panel.border = element_rect(colour = "black", fill=NA, size=0.5))+
  ggtitle('Environmental protection policy')+
  theme(axis.text.x = element_blank())+
  theme(axis.title.x = element_blank())+
  theme(title = element_text(size = 8))


glo_comp3 <- ggplot(SSP_POT_W %>% 
                      filter(Y %in% c(2050)) %>%
                      mutate(Y=factor(Y, levels = c(2050)))%>%
                      mutate(Scenario=factor(Scenario, levels = rev(bks)))%>%
                      ungroup() %>%
                      merge(data.frame(bks, tabs), by.x = 'Scenario', by.y='bks') %>%
                      filter(tabs=="Societal transformation"),
                    aes(x=Scenario, y = pot_w))+
  geom_segment(size = 2, aes(x = Scenario,y = pot_w,xend =Scenario,yend = 0,color=Scenario)) +
  coord_flip()+
  ylim(0,300)+
  scale_color_manual(values = rev(rep(col[2],3)),
                     breaks = bks[7:9],
                     labels = lbs[7:9],
                     name = 'Environmental policy')+
  scale_x_discrete(breaks = bks[7:9],
                   labels = lbs[7:9])+
  geom_text(aes(label=paste(round(pot_w,0), "EJ", sep=' ')),
            position = position_dodge(0.8),hjust=-0.2,vjust=0.4,color='gray30', size=3)+
  theme_minimal() +
  ylab('Bioenergy potential (EJ)') +
  xlab('')+
  theme(axis.text.y=element_text(color = 'grey30', hjust = 0),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.major.y = element_blank(),
        panel.grid.minor.y = element_blank(),
        legend.position = "none",
        plot.margin = margin(0.2, 0.2, 0, 0, "cm")) +
  theme(axis.ticks=element_blank())+
  theme(panel.border = element_rect(colour = "black", fill=NA, size=0.5))+
  ggtitle('Environmental protection policy with societal transformation measure')+
  theme(title = element_text(size = 8))


cb <- ggarrange(glo_comp1, glo_comp2, glo_comp3, ncol = 1, nrow=3, 
                heights = c(1.2,5,4.2), align = 'v')
cb

ggsave("../../../anal_output_r/Figure 5. glo_comp_2050.jpeg", cb,device = 'jpeg', width = 20*0.35,height = 10*0.35, dpi = 600)

## 2100 

glo_comp_2100_1 <- ggplot(SSP_POT_W %>% 
                            filter(Y %in% c(2100)) %>%
                            mutate(Y=factor(Y, levels = c(2100)))%>%
                            mutate(Scenario=factor(Scenario, levels = rev(bks)))%>%
                            ungroup() %>%
                            merge(data.frame(bks, tabs), by.x = 'Scenario', by.y='bks')%>%
                            filter(tabs==" "),
                          aes(x=Scenario, y = pot_w))+
  geom_segment(size = 2, aes(x = Scenario,y = pot_w,xend =Scenario,yend = 0,color=Scenario)) +
  coord_flip()+
  ylim(0,380)+
  scale_color_manual(values = rev(c(col[4])),
                     breaks = bks[1],
                     labels = lbs[1],
                     name = 'Environmental policy')+
  scale_x_discrete(breaks = bks[1],
                   labels = lbs[1])+
  geom_text(aes(label=paste(round(pot_w,0), "EJ", sep=' ')),
            position = position_dodge(0.8),hjust=-0.2,vjust=0.4,color='gray30', size=3)+
  theme_minimal() +
  ylab('Bioenergy potential (EJ)') +
  xlab('')+
  theme(axis.text.y=element_text(color = 'grey30', hjust = 0),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.major.y = element_blank(),
        panel.grid.minor.y = element_blank(),
        legend.position = "none",
        plot.margin = margin(0.2, 0.2, 0, 0, "cm")) +
  theme(axis.ticks=element_blank())+
  theme(panel.border = element_rect(colour = "black", fill=NA, size=0.5))+
  theme(axis.text.x = element_blank())+
  theme(axis.title.x = element_blank())

glo_comp_2100_1

glo_comp_2100_2 <- ggplot(SSP_POT_W %>% 
                            filter(Y %in% c(2100)) %>%
                            mutate(Y=factor(Y, levels = c(2100)))%>%
                            mutate(Scenario=factor(Scenario, levels = rev(bks)))%>%
                            ungroup() %>%
                            merge(data.frame(bks, tabs), by.x = 'Scenario', by.y='bks') %>%
                            filter(tabs=="Environmental policy"),
                          aes(x=Scenario, y = pot_w))+
  geom_segment(size = 2, aes(x = Scenario,y = pot_w,xend =Scenario,yend = 0,color=Scenario)) +
  coord_flip()+
  ylim(0,380)+
  scale_color_manual(values = rev(rep(col[1],5)),
                     breaks = bks[2:6],
                     labels = lbs[2:6],
                     name = 'Environmental policy')+
  scale_x_discrete(breaks = bks[2:6],
                   labels = lbs[2:6])+
  geom_text(aes(label=paste(round(pot_w,0), "EJ", sep=' ')),
            position = position_dodge(0.8),hjust=-0.2,vjust=0.4,color='gray30', size=3)+
  theme_minimal() +
  ylab('Bioenergy potential (EJ)') +
  xlab('')+
  theme(axis.text.y=element_text(color = 'grey30', hjust = 0),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.major.y = element_blank(),
        panel.grid.minor.y = element_blank(),
        legend.position = "none",
        plot.margin = margin(0.2, 0.2, 0, 0, "cm")) +
  theme(axis.ticks=element_blank())+
  theme(panel.border = element_rect(colour = "black", fill=NA, size=0.5))+
  ggtitle('Environmental protection policy')+
  theme(axis.text.x = element_blank())+
  theme(axis.title.x = element_blank())+
  theme(title = element_text(size = 8))
glo_comp_2100_2


glo_comp_2100_3 <- ggplot(SSP_POT_W %>% 
                            filter(Y %in% c(2100)) %>%
                            mutate(Y=factor(Y, levels = c(2100)))%>%
                            mutate(Scenario=factor(Scenario, levels = rev(bks)))%>%
                            ungroup() %>%
                            merge(data.frame(bks, tabs), by.x = 'Scenario', by.y='bks') %>%
                            filter(tabs=="Societal transformation"),
                          aes(x=Scenario, y = pot_w))+
  geom_segment(size = 2, aes(x = Scenario,y = pot_w,xend =Scenario,yend = 0,color=Scenario)) +
  coord_flip()+
  ylim(0,380)+
  scale_color_manual(values = rev(rep(col[2],3)),
                     breaks = bks[7:9],
                     labels = lbs[7:9],
                     name = 'Environmental policy')+
  scale_x_discrete(breaks = bks[7:9],
                   labels = lbs[7:9])+
  
  geom_text(aes(label=paste(round(pot_w,0), "EJ", sep=' ')),
            position = position_dodge(0.8),hjust=-0.2,vjust=0.4,color='gray30', size=3)+
  theme_minimal() +
  ylab('Bioenergy potential (EJ)') +
  xlab('')+
  theme(axis.text.y=element_text(color = 'grey30', hjust = 0),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.major.y = element_blank(),
        panel.grid.minor.y = element_blank(),
        legend.position = "none",
        plot.margin = margin(0.2, 0.2, 0, 0, "cm")) +
  theme(axis.ticks=element_blank())+
  theme(panel.border = element_rect(colour = "black", fill=NA, size=0.5))+
  ggtitle('Environmental protection policy with societal transformation measure')+
  theme(title = element_text(size = 8))
glo_comp_2100_3

cb2100 <- ggarrange(glo_comp_2100_1, glo_comp_2100_2, glo_comp_2100_3, ncol = 1, nrow=3, 
                    heights = c(1.2,5,4.2), align = 'v')

cb2100
ggsave("../../../anal_output_r/Figure S2. glo_comp_2100_new.jpeg", cb2100,device = 'jpeg', width = 20*0.35,height = 10*0.35, dpi = 600)

########################################
##                                    ##
##      Regional potential plot  OECD ##
##                                    ##
########################################

reg <- factor(c("BRA","XLM", "XAF", "OECD", "XSE",
                "IND", "CHN", "XME", "XSA",
                "CIS","XNF"))

reg_lab <- c('Brazil', 'Rest of\nSouth\nAmerica', 'Rest of\nAfrica','OECD',
             'Southeast\nAsia', 'India', 'China', 'Middle\nEast', 'Rest of\nAsia',
             'Former\nSoviet\nUnion', 'North\nAfrica')

reg_comp_oecd <- ggplot(SSP_POT_R_OECD %>% 
                          filter(Y %in% c(2050)) %>%
                          filter(Scenario %in% bks) %>%
                          mutate(Y=factor(Y, levels = c(2050)))%>%
                          mutate(RG=factor(RG, levels = c("BRA","XLM", "XAF", "OECD", "XSE",
                                                          "IND", "CHN", "XME", "XSA",
                                                          "CIS","XNF")))%>%
                          merge(data.frame(RG=reg, reg_lab), by='RG')%>%
                          mutate(reg_lab=factor(reg_lab, levels = c('Brazil', 'Rest of\nSouth\nAmerica', 'Rest of\nAfrica','OECD',
                                                                    'Southeast\nAsia', 'India', 'China', 'Middle\nEast', 'Rest of\nAsia',
                                                                    'Former\nSoviet\nUnion', 'North\nAfrica')))%>%   
                          mutate(Scenario=factor(Scenario, levels = bks))%>%
                          ungroup(),
                        aes(x=Scenario, y = pot_r))+
  geom_segment(size = 1.2, aes(x = Scenario,y = pot_r,xend =Scenario,yend = 0, color=Scenario)) +
  geom_point(size=2,aes(color=Scenario, shape=Scenario))+
  facet_wrap(~reg_lab, nrow = 1,strip.position = "bottom")+
  scale_color_manual(values = c(col[4], rep(col[1],5), rep(col[2],3)),
                     breaks = bks,
                     labels = lbs,
                     name = 'Scenario')+
  scale_shape_manual(values = 0:8,
                     breaks = bks,
                     labels = lbs,
                     name = 'Scenario')+
  scale_y_continuous(breaks = seq(0,70,15),labels = seq(0,70,15), limits = c(0,70))+
  theme_minimal() +
  xlab('Region') +
  ylab('Bioenergy potential (EJ)')+
  theme(axis.text.y=element_text(color = 'black'),
        axis.text.x=element_blank(),
        axis.title.x = element_text(colour = "black", size= 10, vjust = 2)) +
  theme(panel.grid.major.y = element_blank(),
        panel.grid.minor.y = element_blank(),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.spacing.x = unit(0.5, "lines"))+
  theme(legend.position = 'top', legend.box.background = element_blank(),
        plot.margin = margin(0.5, 0.5, 0, 0, "cm"))+
  guides(col = guide_legend(byrow=T))+
  theme(strip.text.x = element_text(size=9,angle = 0,vjust=1))+
  geom_hline(yintercept = 0) +
  theme(legend.position = c(0.67, 0.6)) +
  theme(axis.title.x = element_blank())+
  guides(fill=guide_legend(ncol =2),
         shape=guide_legend(ncol =2),
         color=guide_legend(ncol =2))
  

reg_comp_oecd


reg_comp_oecd_border <- ggarrange(reg_comp_oecd)+
  geom_segment(aes(x = 0.045, y = 0.92, xend = 0.98, yend = 0.92))+
  geom_segment(aes(x = 0.045, y = 0.12, xend = 0.045, yend = 0.92))+
  geom_segment(aes(x = 0.045, y = 0.12, xend = 0.98, yend = 0.12))+
  geom_segment(aes(x = 0.98, y = 0.12, xend = 0.98, yend = 0.92))


ggsave("../../../anal_output_r/Figure 7. reg_comp_2050_oecd.jpeg", reg_comp_oecd_border,device = 'jpeg', 
       width = 22*0.35,height = 15*0.35, dpi = 600)


########################################
##                                    ##
##      Regional area plot  OECD      ##
##                                    ##
########################################

reg_area_OECD <- ggplot(SSP_ARE_R_OECD %>% 
                          filter(Y %in% c(2050)) %>%
                          mutate(are_r=are_r/100000*100) %>% # convert to million ha
                          mutate(Y=factor(Y, levels = c(2050)))%>%
                          mutate(R=factor(RG, levels = c("BRA","XLM", "XAF", "OECD", "XSE",
                                                         "IND", "CHN", "XME", "XSA",
                                                         "CIS","XNF")))%>%
                          merge(data.frame(RG=reg, reg_lab), by='RG')%>%
                          mutate(reg_lab=factor(reg_lab, levels = c('Brazil', 'Rest of\nSouth\nAmerica', 'Rest of\nAfrica','OECD',
                                                                    'Southeast\nAsia', 'India', 'China', 'Middle\nEast', 'Rest of\nAsia',
                                                                    'Former\nSoviet\nUnion', 'North\nAfrica')))%>% 
                          mutate(Scenario=factor(Scenario, levels = bks))%>%
                          ungroup(),
                        aes(x=Scenario, y = are_r))+
#  geom_bar(stat = "identity", position = "dodge", aes(fill=Scenario)) +
  geom_segment(size = 1.2, aes(x = Scenario,y = are_r,xend =Scenario,yend = 0, color=Scenario)) +
  geom_point(size=2,aes(color=Scenario,shape=Scenario))+
  facet_wrap(~reg_lab, nrow = 1,strip.position = "bottom")+
  scale_color_manual(values = c(col[4], rep(col[1],5), rep(col[2],3)),
                     breaks = bks,
                     labels = lbs,
                     name = 'Scenario')+
  scale_shape_manual(values = 0:8,
                     breaks = bks,
                     labels = lbs,
                     name = 'Scenario')+
  scale_y_continuous(breaks = seq(0,300,100),labels = seq(0,300,100), limits = c(0,300))+
  theme_minimal() +
  xlab('Region') +
  ylab(expression(paste("Bio-crop area (million ", ha,")", sep = "")))+
  theme(axis.text.y=element_text(color = 'black'),
        axis.text.x=element_blank(),
        axis.title.x = element_text(colour = "black", size= 10, vjust = 2)) +
  theme(panel.grid.major.y = element_blank(),
        panel.grid.minor.y = element_blank(),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.spacing.x = unit(0.5, "lines"))+
  theme(legend.position = 'top', legend.box.background = element_blank(),
        strip.text.x = element_text(size=9),
        plot.margin = margin(0.5, 0.5, 0, 0, "cm"))+
  guides(col = guide_legend(byrow=T))+
  geom_hline(yintercept = 0) +
  theme(legend.position = c(0.62, 0.72))+
  theme(strip.text.x = element_text(size=9,angle = 0,vjust=1),
        axis.title.x = element_blank())+
  guides(fill=guide_legend(ncol =2),
         shape=guide_legend(ncol =2),
           color=guide_legend(ncol =2))

reg_area_OECD

reg_area_OECD_border <- ggarrange(reg_area_OECD)+
  geom_segment(aes(x = 0.06, y = 0.92, xend = 0.98, yend = 0.92))+
  geom_segment(aes(x = 0.06, y = 0.12, xend = 0.06, yend = 0.92))+
  geom_segment(aes(x = 0.06, y = 0.12, xend = 0.98, yend = 0.12))+
  geom_segment(aes(x = 0.98, y = 0.12, xend = 0.98, yend = 0.92))

ggsave("../../../anal_output_r/Figure S3. reg_area_2050_OECD_border_new.jpeg", reg_area_OECD_border,device = 'jpeg', 
       width = 22*0.35,height = 15*0.35, dpi = 600)

########################################
##                                    ##
## Price percentage and supply curve  ##
##                                    ##
########################################


policy_df <- data.frame(Scenario = bks,
                        Policy= lbs)

supply_curve_df <- SSP_ALL %>% 
  filter(Y==2050)%>%
  mutate(area_cum=area_cum/100000) %>%
  merge(policy_df, by= 'Scenario', all.x=T)%>%
  filter(price<10)%>%
  mutate(Policy=factor(Policy, levels = lbs))
supply_point_df <- supply_curve_df %>%
  mutate(rg = ifelse(price>0.9 & price<1.1,1, NA)) %>%
  mutate(rg = ifelse(price>1.9 & price<2.1,2, rg)) %>%
  mutate(rg = ifelse(price>2.9 & price<3.1,3, rg)) %>%
  mutate(rg = ifelse(price>3.9 & price<4.1,4, rg)) %>%
  mutate(rg = ifelse(price>4.9 & price<5.1,5, rg)) %>%
  mutate(rg = ifelse(price>5.9 & price<6.1,6, rg)) %>%
  mutate(rg = ifelse(price>6.9 & price<7.1,7, rg)) %>%
  mutate(rg = ifelse(price>7.9 & price<8.1,8, rg)) %>%
  mutate(rg = ifelse(price>8.9 & price<9.1,9, rg)) %>%
  mutate(rg = ifelse(price>9.9 & price<10.1,10, rg)) %>%
  #  mutate(rg = ifelse(price>10.9 & price<11.1,11, rg)) %>%
  #  mutate(rg = ifelse(price>11.9 & price<12.1,12, rg)) %>%
  #  mutate(rg = ifelse(price>12.9 & price<13.1,13, rg)) %>%
  #  mutate(rg = ifelse(price>13.9 & price<14.1,14, rg)) %>%
  #  mutate(rg = ifelse(price>14.9 & price<15.1,15, rg)) %>%
  filter(!is.na(rg)) %>%
  group_by(Scenario, rg) %>%
  filter(row_number()==1)

supplycurve_2050 <- ggplot(supply_curve_df %>%
                             filter(Scenario %in% bks)) +
  geom_line(aes(x=w_sup, y=price, linetype = Policy, color=Policy))+
  xlim(0,250)+
  xlab('Bioenergy potential (EJ)') +
  ylab('Production cost (US$/GJ)')+
  theme_minimal() +
  scale_y_continuous(minor_breaks = seq(0, 10, 2), breaks = seq(0, 10, 2), limits = c(0,10))+
  geom_point(data=supply_point_df%>%
               filter(Scenario %in% bks), aes(x=w_sup, y=price, shape=Policy, color=Policy))+
  theme(#axis.line = element_line(size = 0.4, colour = "black"),
    panel.spacing = unit(1, "lines"),
    #        axis.ticks.x = element_line(size = 0.5, colour = "black"),
    #        axis.ticks.y = element_line(size = 0.5, colour = "black"),
    panel.grid.major.y= element_blank(),
    panel.grid.minor.y = element_blank(),
    panel.grid.minor.x = element_blank(),
    panel.grid.major.x = element_blank())+
  theme(panel.border = element_rect(colour = "black", fill=NA, size=0.5))+
  theme(legend.key.width=unit(2,"line"),
        legend.box.background = element_rect()) +
  scale_linetype_manual(values = rep("solid",9),
                        breaks = lbs,
                        labels = lbs,
                        name='Scenario')+
  scale_shape_manual(values = 0:8,
                     breaks = lbs,
                     labels = lbs,
                     name = 'Scenario')+
  scale_color_manual(values = c(col[4], rep(col[1],5), rep(col[2],3)),
                     breaks = lbs,
                     labels = lbs,
                     name = 'Scenario')+
  theme(legend.position = 'right', legend.box.background = element_blank(),
        strip.text.x = element_text(size=9),
        plot.margin = margin(0.5, 0.5, 0, 0, "cm"))+
  guides(col = guide_legend(byrow=T))

#c("solid", "dotted", "dotdash", "longdash", "dashed", "twodash", "F1", "1F", "12345678")


supplycurve_2050


ggsave("../../../anal_output_r/Figure 9. supplycurve_2050.jpeg", supplycurve_2050,device = 'jpeg', width = 12*0.55,height = 6*0.55, dpi = 600)

########################################
##                                    ##
##           Area yield curve         ##
##                                    ##
########################################

area_curve_df <- SSP_ALL %>% 
  filter(Y==2050)%>%
  mutate(area_cum=area_cum/100000*100) %>% # convert to million ha
  merge(policy_df, by= 'Scenario', all.x=T)%>%
  mutate(yield=yield*2) %>% ## reconvert yield back to tonne/ha/yr
  filter(yield<50)%>%
  mutate(Policy=factor(Policy, levels = lbs))

area_point_df <- area_curve_df %>%
  mutate(rgrd = round(area_cum/40)*40) %>%
  filter(rgrd > 0) %>%
  mutate(rg = ifelse(yield >rgrd-0.01 |yield <rgrd + 0.01, rgrd, NA)) %>%
  filter(!is.na(rg)) %>%
  group_by(Scenario, rg) %>%
  filter(row_number()==1)



areayield_2050 <- ggplot(area_curve_df%>%
                           filter(Scenario %in% bks)) +
  geom_line(aes(x=area_cum, y=yield, linetype = Policy, color=Policy))+
  geom_point(data=area_point_df%>%
               filter(Scenario %in% bks), aes(x = area_cum, y = yield, shape=Policy, color=Policy))+
  xlim(0,800)+ylim(0,50) +
  ylab("Yield (tonne/ha/yr)") +
  xlab(expression(paste("Cumulative area (million ", ha,")", sep = ""))) + 
  scale_linetype_manual(values = rep("solid",9),
                        breaks = lbs,
                        labels = lbs,
                        name='Scenario')+
  scale_shape_manual(values = 0:8,
                     breaks = lbs,
                     labels = lbs,
                     name = 'Scenario')+
  scale_color_manual(values = c(col[4], rep(col[1],5), rep(col[2],3)),
                     breaks = lbs,
                     labels = lbs,
                     name = 'Scenario')+
  theme_minimal() +
  theme(legend.key.width=unit(2,"line"),legend.box.background = element_rect()) +
  theme(#axis.line = element_line(size = 0.4, colour = "grey80"),
    #        legend.position = 'none',
    panel.spacing = unit(1, "lines"),
    #        axis.ticks.x = element_line(size = 0.4, colour = "grey80"),
    #        axis.ticks.y = element_line(size = 0.4, colour = "grey80"),
    panel.grid.major.y= element_blank(),
    panel.grid.minor.y = element_blank(),
    panel.grid.minor.x = element_blank(),
    panel.grid.major.x = element_blank()) +
  theme(legend.position = 'right', legend.box.background = element_blank(),
        strip.text.x = element_text(size=9),
        plot.margin = margin(0.5, 0.5, 0, 0, "cm"))+
  #  guides(colour = guide_legend(byrow=T, nrow = 2),
  #         shape = guide_legend(byrow=T, nrow = 2),
  #         linetype = guide_legend(byrow=T, nrow = 2))+
  theme(panel.border = element_rect(colour = "black", fill=NA, size=0.5))


areayield_2050

ggsave("../../../anal_output_r/Figure 6. areayield_2050.jpeg", areayield_2050,device = 'jpeg', width = 12*0.55,height = 6*0.55, dpi = 600)



########################################################################################################

# sensitivity analysis for biodiversity index

library(raster)

biod_idx <- raster('currentzonation.rank.compressed1.tif') %>%
  as.matrix() %>% 
  t() %>% 
  c() %>% 
  data.frame(G=1:(360*720)) %>%
  filter(!is.na(.))

names(biod_idx)[1] <- 'index'



biod_ind_pot <- function(df){
  # this function creates world potential for one scenario under each biodiversity index level
  df_biod <- NULL
  for (i in seq(0.99,0.5,-0.01)) {
    print(i)
    df_biod_temp <- df %>%
      filter(!G %in% (biod_idx %>% dplyr::filter(index >=i) %>% pull(G))) %>% bioe_pric() %>%
      filter(Y==2050) %>%
      pull(quantity) %>%
      sum()
    df_biod <- rbind(df_biod, c(i, df_biod_temp))
  }
  return(df_biod)
}


biod2_biod <- biod_ind_pot(biod2)
all_biod <- biod_ind_pot(all)

demand_biod <- biod_ind_pot(demand)
supply_biod <- biod_ind_pot(supply)
supdem_biod <- biod_ind_pot(supdem)


SSP2_POT_W_biod <- bind_rows(biod2_biod=biod2_biod %>% as.data.frame(), 
                             all_biod=all_biod %>% as.data.frame(), 
                             demand_biod=demand_biod %>% as.data.frame(), 
                             supply_biod=supply_biod %>% as.data.frame(), 
                             supdem_biod=supdem_biod %>% as.data.frame(), .id = 'Scenario')


biod_sens <- ggplot(SSP2_POT_W_biod %>%
         filter(V1>0.75 & V1 <0.95) %>%
         mutate(pcgp = ifelse( Scenario %in% c('biod2_biod', 'all_biod'), "Environmental policy",
                              'Societal transformation')) %>%
         mutate(Scenario=factor(Scenario, levels = c('biod2_biod', 'all_biod', 'demand_biod', 'supply_biod', 'supdem_biod'))), aes(x=V1, y=V2, group=Scenario)) +
  geom_line(aes(color = Scenario), size=1) +
  geom_point(aes(shape=Scenario, color = Scenario), size=2) +
  
  ylab('Bioenergy potential (EJ)') + 
  xlab('Biodiversity index') +
  theme_minimal()+
  scale_y_continuous(breaks = seq(100, 225, 25), labels = seq(100, 225, 25), limits = c(100,225)) +
  scale_x_reverse(breaks = seq(0.95,0.75,-0.05), labels =seq(0.95,0.75,-0.05), limits = c(0.95,0.75))+

  scale_shape_manual(values = 4:8,
                     breaks = c('biod2_biod', 'all_biod', 'demand_biod', 'supply_biod', 'supdem_biod'),
                     labels = lbs[5:9],
                     name = 'Scenario') + 
  scale_color_manual(values = c(rep(col[1],2), rep(col[2],3)),
                     breaks = c('biod2_biod', 'all_biod', 'demand_biod', 'supply_biod', 'supdem_biod'),
                     labels = lbs[5:9],
                     name = 'Scenario')+
  theme(axis.text.y=element_text(color = 'grey30', hjust = 0),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.major.y = element_blank(),
        panel.grid.minor.y = element_blank(),
        legend.box.background = element_blank(), 
        legend.position = c(0.75, 0.75),
        plot.margin = margin(0.2, 0.2, 0, 0, "cm")) +
  theme(axis.ticks=element_blank())+
  theme(panel.border = element_rect(colour = "black", fill=NA, size=0.5)) +
  guides(shape=guide_legend(ncol =1),
         color=guide_legend(ncol =1))

biod_sens

ggsave("../../../anal_output_r/Figure S5. biod_sens_2050.jpeg", biod_sens,device = 'jpeg', width = 8*0.6,height = 6*0.6, dpi = 600)



library(data.table)

potential_map <- supdem %>%
  group_by(G) %>%
  summarise(q=sum(quantity)) %>%
  merge(data.frame(G=1:(720*360)), by='G',all.y=T) %>%
  arrange(G)%>%
  pull(q) %>%
  matrix(byrow = T, nrow = 360) %>%
  as.data.frame()

fwrite(potential_map, "../../../anal_output_r/potential_map.csv", row.names = F)





reg_percentage <-SSP_POT_R_OECD %>% 
  filter(Y==2050) %>% 
  group_by(Scenario) %>% 
  mutate(wordtot = sum(pot_r), wordperc = pot_r/wordtot)



#################################################################################################

## regional average price in Table S1

# contain OECD region
SSP_ALL %>% 
  mutate(RG=ifelse(R %in% c('USA','CAN','JPN','XE25','XOC', 'TUR', 'XER'), 'OECD', R)) %>%
  filter(Y==2050)%>%
  dplyr::select(Scenario, RG, price, quantity,R) %>%
  arrange(Scenario, RG, price) %>%
  group_by(Scenario, RG)%>%
  summarize(price_wm=weighted.mean(price, quantity)) %>%
  filter(Scenario=='supdem') %>% arrange(price_wm)

# all region
SSP_ALL %>% 
  mutate(RG=ifelse(R %in% c('USA','CAN','JPN','XE25','XOC', 'TUR', 'XER'), 'OECD', R)) %>%
  filter(Y==2050)%>%
  dplyr::select(Scenario, price, quantity,R) %>%
  arrange(Scenario, R, price) %>%
  group_by(Scenario, R)%>%
  summarize(price_wm=weighted.mean(price, quantity)) %>%
  filter(Scenario=='supdem') %>% arrange(price_wm)




reg <- 'BRA'


price_quantile_reg_17 <- SSP_ALL %>% 
  mutate(RG=ifelse(R %in% c('USA','CAN','JPN','XE25','XOC', 'TUR', 'XER'), 'OECD', R)) %>%
  filter(Y==2050, Scenario=='supdem')%>%
  dplyr::select(Scenario, price, quantity,R) %>%
  group_by(Scenario, R)%>%
  arrange(Scenario, R, price) %>%
  mutate(quant_cum = cumsum(quantity), perc_reg = quant_cum/max(quant_cum))

price_quantile_reg_oecd <- SSP_ALL %>% 
  mutate(R=ifelse(R %in% c('USA','CAN','JPN','XE25','XOC', 'TUR', 'XER'), 'OECD', R)) %>%
  filter(Y==2050, Scenario=='supdem')%>%
  dplyr::select(Scenario,R, price, quantity) %>%
  group_by(Scenario, R)%>%
  arrange(Scenario, R, price) %>%
  mutate(quant_cum = cumsum(quantity), perc_reg = quant_cum/max(quant_cum))


quantfunc <- function(dataframe,reg,quant){
  
  temp <- filter(dataframe, R==reg) %>%
    mutate(diff = perc_reg - quant/100)%>%
    mutate(pos = ifelse(diff>0, diff, NA),
           neg = ifelse(diff<0, diff, NA)) %>%
    mutate(close_up = min(pos, na.rm = T)) %>%
    mutate(close_dw = max(neg, na.rm = T)) %>%
    mutate(up_pin = pos==close_up,
           dw_pin = neg==close_dw)   %>%
    filter(up_pin|dw_pin) %>%
    mutate(sign=ifelse(pos>0, 'positive', NA)) %>%
    mutate(sign=ifelse(is.na(sign), 'negative', sign)) %>%
    group_by(sign) %>%
    summarise(price = mean(price),
              perc_reg= mean(perc_reg))
    
  pricee =as.numeric((quant/100-temp[2,3])/(temp[1,3] - temp[2,3]) * (temp[1,2] - temp[2,2]) + temp[2,2])
  
  rt <- data.frame(reg=reg, quant=quant, price=pricee, stringsAsFactors = F)
    
  return(rt)
}
  
REGs <- c("BRA","XLM", "XAF", 'USA','CAN','JPN','XE25','XOC', 'TUR', 'XER', "XSE",
                "IND", "CHN", "XME", "XSA","CIS","XNF")

quants <- c(10, 20, 30 ,40,50,60,70,80,90)


df <- NULL

for (reg in REGs) {
  for (i in quants) {
    df <- rbind(df, quantfunc(price_quantile_reg_17,reg,i))
    
  }
  
}


dfoecd <- NULL

for (reg in 'OECD') {
  for (i in quants) {
    dfoecd <- rbind(dfoecd, quantfunc(price_quantile_reg_oecd,reg,i))
    
  }
  
}


exportdf <- rbind(df, dfoecd) %>%
  mutate(price=round(price, 1)) %>%
  dcast(reg~quant) %>%
  arrange(`50`)

write.csv(exportdf, "../../../anal_output_r/price_quantile.csv", row.names = F)


## protected area size 

wdpa <- fread("C:\\Users\\wuwenchao\\Desktop\\wdpa_area.txt")

kba <- fread("C:\\Users\\wuwenchao\\Desktop\\kba_area.txt")


###########################################################################################

## prepare supply curve in csv

sv_fun <- function(df, sce) {
  scedf <- df %>% filter(Y==2050)
  bel <- function(i){
    ret <- scedf %>%
      filter(price<i) %>%
      pull(quantity) %>%
      sum(na.rm = T)
    return(ret)
  }
  supp <- sapply(seq(0,100,0.01), bel)
  df <- data.frame(scenario =sce, `price(USD/GJ)`=seq(0,100,0.01), `quantity(EJ)`=supp)
  return(df)
}

sv_base <- sv_fun(base, "No policy")
sv_soil1 <- sv_fun(soil1, 'Moderate soil protection')
sv_soil2 <- sv_fun(soil2, 'Enhanced soil protection')
sv_biod1 <- sv_fun(biod1, 'Moderate biodiversity protection')
sv_biod2 <- sv_fun(biod2, 'Enhanced biodiversity protection')
sv_all <- sv_fun(all, 'Full environmental policy')
sv_dem <- sv_fun(demand, 'Demand-side policy')
sv_sup <- sv_fun(supply, 'Supply-side policy')
sv_supdem <- sv_fun(supdem, 'Demand- and supply-side policy')


sv_cb <- bind_rows(sv_base, sv_soil1, sv_soil2, sv_biod1, sv_biod2,sv_all,
                    sv_dem, sv_sup, sv_supdem)
names(sv_cb) <- c('scenario', 'price(USD/GJ)', 'quantity(EJ)')


write.csv(sv_cb,'../../../anal_output_r/Table S3. Bioenergy supply curve.csv', row.names = F)


####################################################################################################

# statistic numbers used in the paper
## abstract

## we found that global advanced bioenergy potential under no policy wasxx EJ

base %>% filter(Y==2050) %>% pull(quantity) %>% sum() %>% round()

## and xx EJ could be produced under US$5/GJ

base %>% filter(Y==2050, price <5) %>% pull(quantity) %>% sum() %>% round()

## these figures were xx and xx under full environmental policy

all %>% filter(Y==2050) %>% pull(quantity) %>% sum() %>% round()
all %>% filter(Y==2050, price <5) %>% pull(quantity) %>% sum() %>% round()

## societal transformation measures effectively promote them to 

supdem %>% filter(Y==2050) %>% pull(quantity) %>% sum() %>% round()
supdem %>% filter(Y==2050, price <5) %>% pull(quantity) %>% sum() %>% round()


## result section


# regional potential 
## in the no policy scenario, Brazil was projected to be the largest supplier of bioenergy

SSP_POT_R_OECD %>% filter(Y==2050, Scenario=='base') %>% arrange(pot_r)

68.3/245
66.9/245
54/245

## these three regions accounted for about three-fourths () of 

SSP_POT_R_OECD %>% filter(Y==2050) %>% mutate(three = ifelse(RG %in% c('BRA','XLM', 'XAF'), pot_r,0)) %>%
  group_by(Scenario) %>%
  summarise(threetot = sum(three),
            tot17 = sum(pot_r)) %>%
  mutate(fract = round(threetot/tot17*100))%>%
  arrange(fract)
  
  
## for example, the global average ratio of the amount of bioenergy potential production in the 
## full environmental policy scenario to the amount produced under the no policy scenario was   
  

149/245

## but the regional ratio varied from 

SSP_POT_R_OECD %>% filter(Y==2050, Scenario=='all') %>% pull(perc) %>% range()
SSP_POT_R_OECD %>% filter(Y==2050, Scenario=='all') %>% arrange(perc)

## and it contributed xx of the xx global increase in the demand- and supply-side policy scenario

186-149

SSP_POT_R_OECD %>% filter(Y==2050, RG=='XAF', Scenario=='supdem')
SSP_POT_R_OECD %>% filter(Y==2050, RG=='XAF', Scenario=='all')

56.9-28.1

## production cost section 


## Under the demand- and supply-side policy scenario, xx ej was available at a production cost of 

supdem %>% filter(Y==2050, price<3) %>% pull(quantity) %>% sum()

80/186

supdem %>% filter(Y==2050, price<5) %>% pull(quantity) %>% sum()
143/186

## for a given price level, the economically feasible quantity will be lower. For example, at a production cost of US$5/GJ, 

base %>% filter(Y==2050, price<5) %>% pull(quantity) %>% sum()
all %>% filter(Y==2050, price<5) %>% pull(quantity) %>% sum()


## Specifically, combined demand- and supply-side policy increased total potential by 


186-149

supdem %>% filter(Y==2050, price < 5) %>% pull(quantity) %>% sum()
all %>% filter(Y==2050, price < 5) %>% pull(quantity) %>% sum()

143-110

####################################################################################

## 外部評価 

GA <- rgdx.param("E:\\bioenergypotRR_soci_dem\\prog\\data\\data_prep.gdx", symName='GA') %>%
  mutate(G=as.numeric(as.character(G)))

protect_bs <- rgdx.param("E:\\bioenergypotRR_soci_dem\\prog\\data\\policydata.gdx", symName='protect_bs') %>%
  rename(G=i)%>%
  mutate(G=as.numeric(as.character(G))) %>%
  merge(GA,by='G', all.x = T) %>%
  filter(!is.na(GA)) %>%
  mutate(size=value*GA) %>%
  pull(size) %>%
  sum()/1000

protect_all <- rgdx.param("E:\\bioenergypotRR_soci_dem\\prog\\data\\policydata.gdx", symName='protect_all') %>%
  rename(G=i)%>%
  mutate(G=as.numeric(as.character(G))) %>%
  merge(GA,by='G', all.x = T) %>%
  filter(!is.na(GA)) %>%
  mutate(size=value*GA) %>%
  pull(size) %>%
  sum()/1000

protect_all_95 <- rgdx.param("E:\\bioenergypotRR_soci_dem\\prog\\data\\policydata.gdx", symName='protect_all') %>%
  rename(G=i)%>%
  mutate(G=as.numeric(as.character(G))) %>%
  merge(GA,by='G', all.x = T) %>%
  filter(!is.na(GA)) %>%
  mutate(value=ifelse(G %in% ohashi, 1, value)) %>%
  mutate(size=value*GA) %>%
  pull(size) %>%
  sum()/1000

severe_land <- rgdx.param("E:\\bioenergypotRR_soci_dem\\prog\\data\\policydata.gdx", symName='severe_land') %>%
  rename(G=i)%>%
  mutate(G=as.numeric(as.character(G))) %>%
  merge(GA,by='G', all.x = T) %>%
  filter(!is.na(GA)) %>%
  mutate(size=value*GA) %>%
  pull(size) %>%
  sum()/1000

serious_land <- rgdx.param("E:\\bioenergypotRR_soci_dem\\prog\\data\\policydata.gdx", symName='serious_land') %>%
  rename(G=i)%>%
  mutate(G=as.numeric(as.character(G))) %>%
  merge(GA,by='G', all.x = T) %>%
  filter(!is.na(GA)) %>%
  mutate(size=value*GA) %>%
  pull(size) %>%
  sum()/1000

serious_land_allpolicy <- rgdx.param("E:\\bioenergypotRR_soci_dem\\prog\\data\\policydata.gdx", symName='serious_land_allpolicy') %>%
  rename(G=i)%>%
  mutate(G=as.numeric(as.character(G))) %>%
  merge(GA,by='G', all.x = T) %>%
  filter(!is.na(GA)) %>%
  mutate(size=value*GA) %>%
  pull(size) %>%
  sum()/1000




prot1 <- SSP_POT_W %>% 
                      filter(Y %in% c(2050)) %>%
                      mutate(Y=factor(Y, levels = c(2050)))%>%
                      mutate(Scenario=factor(Scenario, levels = rev(bks)))%>%
                      ungroup() %>%
                      merge(data.frame(bks, tabs), by.x = 'Scenario', by.y='bks')%>%
                      filter(tabs==" ")
prot2$pot_w <- -protect_bs

prot2 <- SSP_POT_W %>% 
  filter(Y %in% c(2050)) %>%
  mutate(Y=factor(Y, levels = c(2050)))%>%
  mutate(Scenario=factor(Scenario, levels = rev(bks)))%>%
  ungroup() %>%
  merge(data.frame(bks, tabs), by.x = 'Scenario', by.y='bks')%>%
  filter(tabs=="Environmental policy")

prot2$pot_w <- -c(protect_all_95+serious_land_allpolicy, 
                  protect_all, protect_all_95, 
                  severe_land+protect_bs, serious_land+protect_bs)


prot3 <- SSP_POT_W %>% 
  filter(Y %in% c(2050)) %>%
  mutate(Y=factor(Y, levels = c(2050)))%>%
  mutate(Scenario=factor(Scenario, levels = rev(bks)))%>%
  ungroup() %>%
  merge(data.frame(bks, tabs), by.x = 'Scenario', by.y='bks')%>%
  filter(tabs=="Societal transformation")

prot3$pot_w <- -rep(protect_all_95+serious_land_allpolicy,3)

##########################################
glo_comp1_protsize <- ggplot(prot1,
                    aes(x=Scenario, y = pot_w))+
  geom_segment(size = 2, aes(x = Scenario,y = pot_w,xend =Scenario,yend = 0,color=Scenario)) +
  coord_flip()+
  ylim(-4000,0)+
  scale_color_manual(values = rev(c(col[4])),
                     breaks = bks,
                     labels = lbs,
                     name = 'Environmental policy')+
  scale_x_discrete(breaks = bks,
                   labels = lbs)+
  geom_text(aes(label=paste(-round(pot_w,0), "M.H.", sep=' ')),
            position = position_dodge(0.8),hjust=1.2,vjust=0.4,color='gray30', size=3)+
  theme_minimal() +
  xlab('')+
  theme(axis.text.y=element_text(color = 'grey30', hjust = 0),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.major.y = element_blank(),
        panel.grid.minor.y = element_blank(),
        legend.position = "none",
        plot.margin = margin(0.2, 0.2, 0, 0, "cm")) +
  theme(axis.ticks=element_blank())+
  theme(panel.border = element_rect(colour = "black", fill=NA, size=0.5))+
  theme(axis.text.x = element_blank())+
  theme(axis.title.x = element_blank())+
  theme(axis.text.y = element_blank())

glo_comp1_protsize

glo_comp2_protsize <- ggplot(prot2,
                    aes(x=Scenario, y = pot_w))+
  geom_segment(size = 2, aes(x = Scenario,y = pot_w,xend =Scenario,yend = 0,color=Scenario)) +
  coord_flip()+
  ylim(-4000,0)+
  scale_color_manual(values = rev(rep(col[1],5)),
                     breaks = bks,
                     labels = lbs,
                     name = 'Environmental policy')+
  scale_x_discrete(breaks = bks,
                   labels = lbs)+
  geom_text(aes(label=paste(-round(pot_w,0), "M.H.", sep=' ')),
            position = position_dodge(0.8),hjust=1.2,vjust=0.4,color='gray30', size=3)+
  theme_minimal() +
  ylab('Bioenergy potential (EJ)') +
  xlab('')+
  theme(axis.text.y=element_text(color = 'grey30', hjust = 0),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.major.y = element_blank(),
        panel.grid.minor.y = element_blank(),
        legend.position = "none",
        plot.margin = margin(0.2, 0.2, 0, 0, "cm")) +
  theme(axis.ticks=element_blank())+
  theme(panel.border = element_rect(colour = "black", fill=NA, size=0.5))+
  ggtitle('Environmental protection policy')+
  theme(axis.text.x = element_blank())+
  theme(axis.title.x = element_blank())+
  theme(title = element_text(size = 8))+
  theme(axis.text.y = element_blank())

glo_comp2_protsize

glo_comp3_protsize <- ggplot(prot3,
                    aes(x=Scenario, y = pot_w))+
  geom_segment(size = 2, aes(x = Scenario,y = pot_w,xend =Scenario,yend = 0,color=Scenario)) +
  coord_flip()+
  scale_y_continuous(breaks = -c(0,1000,2000,3000,4000), labels = c(0,1000,2000,3000,4000),
                     limits = c(-4000,0))+
  ylab('優先保護区域面積(Million Hectares)') +
  scale_color_manual(values = rev(rep(col[2],3)),
                     breaks = bks,
                     labels = lbs,
                     name = 'Environmental policy')+
  scale_x_discrete(breaks = bks,
                   labels = lbs)+
  geom_text(aes(label=paste(-round(pot_w,0), "M.H.", sep=' ')),
            position = position_dodge(0.8),hjust=1.2,vjust=0.4,color='gray30', size=3)+
  theme_minimal() +
  xlab('')+
  theme(axis.text.y=element_text(color = 'grey30', hjust = 0),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.major.y = element_blank(),
        panel.grid.minor.y = element_blank(),
        legend.position = "none",
        plot.margin = margin(0.2, 0.2, 0, 0, "cm")) +
  theme(axis.ticks=element_blank())+
  theme(panel.border = element_rect(colour = "black", fill=NA, size=0.5))+
  ggtitle('Environmental protection policy with societal transformation measure')+
  theme(title = element_text(size = 8))+
  theme(axis.title.x = element_text(size = 15))+
  theme(axis.text.y = element_blank())

glo_comp3_protsize


p1 <- glo_comp1+theme(axis.text.y = element_blank())
p2 <-glo_comp2+theme(axis.text.y = element_blank())
p3 <- glo_comp3+theme(axis.text.y = element_blank())+ylab('バイオエネルギーポテンシャル(EJ)')+
  theme(axis.title.x = element_text(size = 15))

col1 <- ggarrange(glo_comp1_protsize, glo_comp2_protsize,glo_comp3_protsize, ncol = 1, nrow=3, 
                  heights = c(1.2,5,4.2), align = 'v')

col2 <- ggarrange(p1, p2,p3, ncol = 1, nrow=3, 
                  heights = c(1.2,5,4.2), align = 'v')

plotall <- ggarrange(col1,col2, ncol = 2, widths = c(2.1,2)
                     )

plotall

ggsave("glo_protsize_potential.jpeg", plotall,device = 'jpeg', width = 30*0.35,height = 9*0.35, dpi = 600)

