
seps = unlist(strsplit(OUT, .Platform$file.sep))
PATH = paste(seps[-length(seps)], collapse=.Platform$file.sep)

OUT_ORIG = paste(seps[-length(seps)][-1], collapse=.Platform$file.sep)



## Es crea el directori on es guardaran les sortides
dir.create(PATH, showWarnings = F, recursive= T)
dir.create(paste0(PATH, '/figure'), showWarnings = F, recursive= T)

library(knitr)
library(markdown)
opts_knit$set(base.dir = PATH)

knit(input=IN, output=paste0(OUT, '.md'))
markdownToHTML(paste0(OUT, '.md'), OUT, stylesheet = '/home/idiap/projects.thor/hyfi/markdown.css')

file.rename(OUT, OUT_ORIG)
