library(graphics)
library(RColorBrewer)
library(glue)
library(hash)
library(ggplot2)

make_list <- function(keys, texts){
  if(length(keys) != length(texts)){stop("keys length unequal to texts length!")}
  r = lapply(c(1:length(keys)), \(x){list(key = keys[x], text = texts[x])})
  return(r)
}

makeCard <- function(title, content, size = 12, style = "") {
  div(
    class = glue("card ms-depth-8 ms-sm{size} ms-xl{size}"),
    style = style,
    Stack(
      tokens = list(childrenGap = 5),
      Text(variant = "large", title, block = TRUE),
      content
    )
  )
}

makeDropout <- function(input, id, opt, name){
  if(!is.null(input)){
    Dropdown.shinyInput(inputId = id,options = make_list(opt, opt), label = name, value = opt[1])
  }
  else{NULL}
}

makePieChart <- function(input, percentage = FALSE, logFreq = TRUE){
  if(is.null(input)){return(NULL)}
  if(is.null(percentage)){percentage = FALSE}
  if(is.null(logFreq)){logFreq = FALSE}
  cellTypeConstitution <- data.frame(table(input))
  colnames(cellTypeConstitution) <- c("cell_type", "Freq")
  cellTypeConstitution$Percent = round(cellTypeConstitution$Freq*100/sum(cellTypeConstitution$Freq),2)
  color <- c(brewer.pal(12,"Paired"), brewer.pal(9,"Set1"), brewer.pal(8, "Dark2"), brewer.pal(4, "Set2"))
  color <- unique(color)
  color <- color[1:nrow(cellTypeConstitution)]
  if(percentage){
    tagLabel = with(cellTypeConstitution, paste0(cell_type, "(", Percent, "%)"))
  }
  else{
    tagLabel = with(cellTypeConstitution, paste0(cell_type, "(", Freq, ")"))
  }
  if(logFreq){freq <- log1p(cellTypeConstitution$Freq)}
  else{freq <- cellTypeConstitution$Freq}
  r <- pie(freq, 
           labels = tagLabel,
           radius = 1,
           cex = 0.8,
           col = color,
           main = "Cell type proportions"
       )
  return(r)
}

makeCellTypeHash <- function(input){
  #细胞类型字典
  {typeDict <- list(
    'B' = c("Plasma cell", "Memory B cell", "Naive B cell"),
    "Epithelial" = c("Epithelial"),
    "Fibroblast" = c("iCAF", "myCAF","Pericyte"),
    "Endothelial" = c("Immature Endothelial cell",
                      "Artery Endothelial cell",
                      "Endothelial Tip cell",
                      "Lymphatic Endothelial cell",
                      "Capillary Endothelial cell"),
    "Myeloid" = c("Mast cell", "Neutrophil",
                  "Macrophage", "Monocyte",
                  "pDC", "cDC1", "cDC2"),
    'T' = c("Exhausted CD8+ T cell", "Effector CD8+ T cell", 
            "Naive CD8+ T cell", "Memory CD8+ T cell",
            "Exhausted CD4+ T cell", "Th", "Treg", "Tprolif",
            "Naive CD4+ T cell", "Memory CD4+ T cell",
            "Gamma-delta T cell", "NK", "NKT")
  )}
  all_celltype <- unique(input)
  main_celltype <- sapply(all_celltype, \(x){
      index <- which(unlist(lapply(typeDict, \(y){
        x %in% y
       })))
      return(names(typeDict)[index])
    })
  r <- hash(all_celltype, main_celltype)
  return(r)
}

typeSubtype <- function(input){
  if(is.null(input)){return(NULL)}
  cellTypeHash <- makeCellTypeHash(input)
  r <- hash::values(cellTypeHash, keys = input)
  return(r)
}

makeSpatialPlot <- function(input, spot_size = 0.1){
  if(is.null(input)){return(NULL)}
  if(is.null(spot_size)){spot_size = 0.1}
  inData <- input
  colnames(inData) <- c("x", "y", "cell_type")
  r <- ggplot(inData, aes(x=x,y=y,color=cell_type))+
       geom_point(size = spot_size)
  return(r)
}






