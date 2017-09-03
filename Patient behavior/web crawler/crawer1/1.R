
load("fb_oauth")


group<-getGroup(group_id=209561432418821, token=fb.oauth, n = 100, since = NULL, until = NULL,
                feed = TRUE, api = NULL)
write.csv(group,"group.csv")
