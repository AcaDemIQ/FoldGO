\docType{class}
\name{foldspectest_class}
\alias{foldspectest_class}
\alias{FoldSpecTest}
\alias{getFStable}
\alias{getNFStable}
\alias{getResultTable}
\alias{getFStable,FoldSpecTest-method}
\alias{getNFStable,FoldSpecTest-method}
\alias{getResultTable,FoldSpecTest-method}
\title{FoldSpecTest S4 class}
\description{
FoldSpecTest object calculates test on fold-specificity and stores all resulting data needed for further analysis.
It takes object which is instance of subclass of AnnotGroups class (e.g. FuncAnnotGroupsTopGO class) as a minimal set of input parameters.
For more details see Constructor section.
}
\section{Constructor}{

\code{FoldSpecTest(annotgroups, fdrstep1, fdrstep2, padjmethod, fisher_alternative)}, where:
\describe{
\item{}{\code{annotgroups} - object of FuncAnnotGroups class}
\item{}{\code{fdrstep1} - FDR threshold for 1 step of fold-specificty recognition procedure}
\item{}{\code{fdrstep2} - FDR threshold for 2 step of fold-specificty recognition procedure}
\item{}{\code{padjmethod} - method for multiple testing correction (to see all possible methods print: p.adjust.methods)
Benjamini-Hochberg by default}
\item{}{\code{fisher_alternative} - indicates the alternative hypothesis and must be one of "two.sided", "greater" or "less".
You can specify just the initial letter. Only used in the 2 by 2 case.}
}
}

\section{Accessors}{

In the code examples below \code{object} is an object of FoldSpecTest class
\describe{
\item{}{\code{getFStable(object)} - returns dataframe with fold-change-specific terms and related data}
\item{}{\code{getNFStable(object)} - returns dataframe with not fold-change-specific terms and related data}
\item{}{\code{getResultTable(object)} - returns dataframe with both fold-change-specific and not fold-change-specific terms}
\item{}{\code{getWholeIntName(object)} - returns name of largest fold-change interval (DEGs interval)}
}
}

\examples{
# FoldSpecTest function requires only object of FuncAnnotGroups class as a
# minimal set of parameters. In the example up_annotobj is an object of FuncAnnotGroups class
# compiled from lists of up-regulated genes from rna-seq experiment on auxin treatment
# of Arabidopsis thaliana roots [FoldGO::up_annotobj].
FoldSpecTest(up_annotobj)

# FoldSpecTest function with custom parameters
fs_up <- FoldSpecTest(up_annotobj, fdrstep1 = 0.2, fdrstep2 = 0.01, padjmethod = "BY")

# get dataframe with fold-change-specific terms
getFStable(fs_up)

# get dataframe with not fold-change-specific terms
getNFStable(fs_up)

# get dataframe with both fold-change-specific and not fold-change-specific terms
getResultTable(fs_up)

# get name of largest fold-change interval (DEGs interval)
getWholeIntName(fs_up)
}
