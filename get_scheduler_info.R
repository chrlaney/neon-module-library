library(httr)
library(XML)

req <- httr::GET("http://prod-os-ds-1.ci.neoninternal.org:8080/osDataService/scheduler-state?transition-type-code=GENERIC",
                 accept="application/vnd.neoninc.os.scheduler-state-list-v1.0+xml")
sched <- XML::xmlParse(httr::content(req, as="text", encoding = "UTF-8"))
sched.list <- sched["//schedulerState"]
sched.list[[1]]