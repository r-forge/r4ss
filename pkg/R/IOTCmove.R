IOTCmove <-
  function(replist=NULL,moveage=5,
           moveseas=1,legend=FALSE,title=NULL,
           areanames=c("R1","R2","R3","R4","R5"),
           ...)
{
  # Indian Ocean Tuna Commission 5-area model:
  polygonlist <- list(
    region1=data.frame(
      x=c(40, 77, 75, 60),
      y=c(10, 10, 30, 30)),
    region2=data.frame(
      x=c(38, 75, 75, 60, 60, 38),
      y=c(10, 10,-15,-15,-10,-10)),
    region3=data.frame(
      x=c( 40, 60, 60, 40, 40, 20, 20),
      y=c(-10,-10,-30,-30,-40,-40,-35)),
    region4=data.frame(
      x=c( 60,120,120, 40, 40, 60),
      y=c(-15,-15,-40,-40,-30,-30)),
    region5=data.frame(
      x=c( 75,100,100,110,110,130,130, 75),
      y=c( 10, 10, -5, -5,-10,-10,-15,-15))
    )

  xytable <- matrix(c(62,  20,
                      62,   0,
                      50, -20,
                      80, -25,
                      90,  -5),
                    nrow=5,ncol=2,byrow=T)
  colvec=c("purple","green","blue","orange3","yellow")
  for(i in 1:5){
    temp <- as.numeric(col2rgb(colvec[i])[,1])
    temp <- (255 - (255 - temp)/3)/255
    colvec[i] <- rgb(temp[1],temp[2],temp[3])
  }

  SSplotMovementMap(replist=replist,
                    xlim=c(15,135),
                    ylim=c(-45,40),
                    polygonlist=polygonlist,
                    colvec=colvec,
                    xytable=xytable,
                    moveage=moveage,
                    moveseas=moveseas,
                    legend=legend,
                    title=title,
                    areanames=areanames,
                    ...
                    )
}
