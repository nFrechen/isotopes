library(rvest)

nucl <- html_session("https://websso.iaea.org/login/login.fcc?TYPE=33554433&REALMOID=06-ef4f28c9-f8dc-467e-8186-294fdf5e627b&GUID=&SMAUTHREASON=0&METHOD=GET&SMAGENTNAME=$SM$e5utW7BvliO1ED%2btYsJY7ob8iaMTTe5bnP3rVRRDKcLtPDyvx7kOY%2b6YSwtMTLAv&TARGET=$SM$HTTPS%3a%2f%2fwebsso%2eiaea%2eorg%2flogin%2fbounce%2easp%3fDEST%3d$$SM$$HTTPS$%3a$%2f$%2fwebsso$%2eiaea$%2eorg$%2flogin$%2fredirect$%2easp$%3ftarget$%3dhttp$%3a$%2f$%2fnucleus$%2eiaea$%2eorg$%2fwiser$%2fgnip$%2ephp$%3fll_latlon$%3d$%26ur_latlon$%3d$%26country$%3dGermany$%26wmo_region$%3d$%26date_start$%3d1953$%26date_end$%3d2016$%26action$%3dSearch")

form <- html_form(nucl)[[1]]
password <- readline(prompt = "Bitte Passwort eingeben: ")
form2 <- set_values(form, USER= "jklasd", PASSWORD=password)
form2$url <- ""

nucl2 <- submit_form(session=nucl, form=form2)
nucl2 <- follow_link(nucl2, "All")

csv_links <- html_nodes(nucl2, css="a") %>% html_text() == "csv"

downloadLinks <- html_nodes(nucl2, css="a")[csv_links] %>% html_attr(name="href")

baseurl <- "https://nucleus.iaea.org/wiser/"

downloadLinks <- paste0(baseurl, downloadLinks)

folder <- "data"

dir.create(folder)

destfiles <- paste0(html_table(nucl2)[[2]][, "WMO Code"], ".csv")

for(i in 1:length(downloadLinks)){
  jump_to(nucl2, url=downloadLinks[i])$response$content %>%
    writeBin(file.path(folder, destfiles[i]))
}
