####This is an updated repository (from the May 2018 repository status-threat-analysis-for-socius) that includes new analysis for the reply to Mutz's comment on the July 2018 article published in Socius.

  * The original article is available at https://doi.org/10.1177/2378023118788217, as of July 24, 2018. 

##### These are the additional files in this updated repository that generate analysis:

1.  additional-results-for-reply-to-Mutz.do, log (from July 8, 2018)

  * Mostly analysis of vote switching for Socius reply

2.  mutz-code-panel-edited-v2-sdo-problems.do

  * This file takes the do file mutz-code-panel-edited-v2.do from May 2018, which was posted to GitHub with the July 2018 article published in Socius, and uses the same setup.  That setup is based on  Mutz's original code that she released, along with additional code chunks for the critic.
  * The current file includes a second set of additional code chunks for subsequent work.  This additional work clarifies the sdo mismatch problem investigated in October and November 2018 when tidying up this analysis to explain fixed effect models, first presented in Rostock on July 2, 2018.  

    Conclusions:  

    The results of the Socius article and the Rostock lecture are not affected by the sdo mismatch, since the "pre" sdo measure was not used for either set of analyses.  However, in order to be consistent with the methodology literature in providing correct explanations, I need to have consistently measured variables.  The relevant changes identified and suggested by the analysis in the current file are carried forward and implemented in
      - use-mutz-to-explain-fe-models.do and (implicitly, then also use-mutz-to-explain-fe-models-two-predictors.do).

3.  use-mutz-to-explain-fe-models.do, .log

  * This file takes the do file mutz-code-panel-edited-v2.do from May 2018, which was posted to GitHub with the July 2018 article published in Socius, and uses the same setup.  That setup is based on  Mutz's original code that she released, along with additional code chunks for the critic.

  The current file includes a second set of additional code chunks for subsequent work in order to explain a wider range of models than appeared in the Socius article.  This analysis was prepared when the Socius Reply was in production. As a result, all new chunks are labeled below as "CHUNK for SociusReply." [Many parts of this do file were, however, written in advance of the July 2, 2018 lecture at Rostock, slides for which are posted at https://osf.io/fjr7e/ .] 

  In addition, an intermediate file mutz-code-panel-edited-v2-sdo-problems.do exists that updates mutz-code-panel-edited-v2.do in order to consider the sdo mismatch problem clarified in October and November 2018 when tidying up this file for distribution.

  The results of the Socius article and the Rostock lecture are not affected by the sdo mismatch, since the "pre" sdo measure was not used for either set of analyses.  However, in order to be consistent with the methodology literature in providing correct explanations, I need to have consistently measured variables.  The relevant changes identified and suggested by the analysis in mutz-code-panel-edited-v2-sdo-problems.do are carried forward and implemented in the current file.  
    
  Additional notes: 

    1.  Some of the code that generates results in mutz-code-panel-edited-v2.do is commented out in this file.  It is the same code and there is no reason to regenerate the results and write over the existing outreg files.  It is re-run already in the intermediate file mutz-code-panel-edited-v2-sdo-problems.do.

    2.  Some deprecated code is aso present below, as it is the vestige of the original Rostock-lecture code.  This code is for additional fe models that cluttter the explanations and outreg files.  They are commented out in this version, but could be restored, perhaps with 
     some minor editing.

4.  use-mutz-to-explain-fe-models-two-predictors.do, .log

 * This file carries on from use-mutz-to-explain-fe-models.do in order to 
  demonstrate that the basic reasoning (with the slight exception of drift
  complications) is the same for models with more than one predictor.


##### Additional files added to the repository that are called in the files above:

- reshape-in-loop-chunk.do
- reshape-in-loop-chunk-two-vars.do


