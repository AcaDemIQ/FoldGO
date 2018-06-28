#--------------------GETTERS-------------------
#' Accessor method for list of functional annotation result tables
#'
#' @param FuncAnnotGroups - object of FuncAnnotGroups class
#'
#' @return - list with filenames as keys and annotaton data frames as values
#' @export
#'
#' @examples
#' gaf_path <- system.file("extdata", "gene_association.tair", package = "FsgorS4package", mustWork = TRUE)
#' gaf <- GAFReader(file = gafpath)
#' gaf_list <- convertToList(gaf)
#' annotobj <- FuncAnnotGroupsTopGO(up_groups,"BP", gene2GO = gaf_list, annot = topGO::annFUN.GO2genes, bggenes = bggenes, padjmethod = "BH", qitborder = 10, genesannot = 1)
#' getResultList(annotobj)
setMethod(
  f = "getResultList",
  signature = "FuncAnnotGroups",
  definition = function(object) {
    return(object@resultlist)
  }
)
#----------------------------------------------
#' Functional annotation test
#'
#' @param FuncAnnotGroupsTopGO - object of FuncAnnotGroupsTopGO class
#'
#'
setMethod(
  f = "runFuncAnnotTest",
  signature = "FuncAnnotGroupsTopGO",
  definition = function(object) {
    namespace <- object@namespace
    genesannot <- object@genesannot
    padjmethod <- object@padjmethod
    qitborder <- object@qitborder
    algorithm <- object@algorithm
    statistic <- object@statistic

    quan_genes <- getGroups(object@genegroups)
    quan_names <- getIntNames(object@genegroups)

    bggenes <- object@bggenes

    myInterestingGenes <- quan_genes[[quan_names[1]]]
    geneList <-
      factor(as.integer(bggenes %in% myInterestingGenes))
    names(geneList) <- bggenes
    result_list <- list()

    if (object@mapping == "custom"){
      GOdata <- new(
        "topGOdata",
        ontology = namespace,
        allGenes = geneList,
        annot = object@annot,
        GO2genes = object@GO2genes,
        nodeSize = genesannot
      )
    } else {
      GOdata <- new("topGOdata",
                    ontology = namespace,
                    allGenes = geneList,
                    annot = object@annot,
                    mapping = object@mapping,
                    ID = object@ID,
                    nodeSize = genesannot)
    }


    resultFisher <-
      topGO::runTest(GOdata, algorithm = algorithm, statistic = statistic)
    data_table <-
      topGO::GenTable(GOdata,
                      classicFisher = resultFisher,
                      topNodes = length(topGO::usedGO(GOdata)))
    #For case when there are less-than sign in pvalue column
    temp_padj <- p.adjust(sub("<\\s", "",
                          data_table$classicFisher),
                          method = padjmethod)

    data_table$padj <- temp_padj
    data_table$qtot <- topGO::numSigGenes(GOdata)
    data_table$namespace <- topGO::ontology(GOdata)
    data_table <-
      data_table[data_table$Significant >= qitborder, ]
    colnames(data_table) <-
      c(
        "GO_id",
        "name",
        "Annotated",
        "qit",
        "Expected",
        "pvalue",
        "padj",
        "qtot",
        "namespace"
      )
    result_list[[quan_names[1]]] <- data_table

    for (quan_name in quan_names[-1]) {
      myInterestingGenes <- quan_genes[[quan_name]]

      geneList <-
        factor(as.integer(bggenes %in% myInterestingGenes))
      names(geneList) <- bggenes

      GOdata <- topGO::updateGenes(GOdata, geneList)
      resultFisher <-
        topGO::runTest(GOdata, algorithm = algorithm, statistic = statistic)
      data_table <- topGO::GenTable(GOdata,
                                    classicFisher = resultFisher,
                                    topNodes = length(topGO::usedGO(GOdata)))

      #For case when there are less-than sign in pvalue column
      temp_padj <- p.adjust(sub("<\\s", "",
                            data_table$classicFisher),
                            method = padjmethod)

      data_table$padj <- temp_padj
      data_table$qtot <- topGO::numSigGenes(GOdata)
      data_table$namespace <- topGO::ontology(GOdata)
      data_table <-
        data_table[data_table$Significant >= qitborder, ]
      colnames(data_table) <-
        c(
          "GO_id",
          "name",
          "Annotated",
          "qit",
          "Expected",
          "pvalue",
          "padj",
          "qtot",
          "namespace"
        )
      result_list[[quan_name]] <- data_table

    }
    object@resultlist <- result_list
    return(object)
  }
)