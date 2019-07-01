#' Draws a gradient legend for a climate stripes plot
#'
#' @param xleft the lower left x coordinate of the legend
#' @param ybottom the lower left y coordinate of the legend
#' @param xright the upper right x coordinate of the legend
#' @param ytop the upper right y coordinate of the legend
#' @param col1 the colour for the lowest value of the temperature vector
#' @param col2 the colour for the highest value of the temperature vector. A gradient between col1 and col2 is drawn for the other colours
#' @param ncolours the number of colours to show on the legend. Default is 500, a large number produces a smooth legend colour gradient
#' @param labels default TRUE. If TRUE then values you supply (var.min.label) and (var.max.label) are shown on the legend
#' @param var.min.label the val.ue for the highest temperature to show on the legend
#' @param var.max.label the value for the lowest temperature to show on the legend
#' @param legend.text.col colour of the legend text
#' @description This draws a colour gradient legend for use as a climate stripes legend. It uses rect to draw many rectangles (500) and colours
#'       each with a ramp palette so that it appears as a smooth gradient. It is also possible to do this as a rasterImage but these images
#'       can be hard to work with and do not scale properly especially for multiplot layouts.
#' @seealso rect colorRampPalette
#' @export
colour.gradient.legend.f= function(xleft,ybottom,xright,ytop,col1="blue",col2="red",ncolours=500,labels=T,var.min.label,var.max.label, legend.text.col){
  tempcol=colorRampPalette(c(col1,col2))(ncolours)
  xlefts= rep(xleft,length=ncolours)
  xrights= rep(xright,length=ncolours)
  ybottoms= seq(ybottom,ytop-1/ncolours,length=ncolours)
  ytops= ybottoms+1/ncolours
  for (i in 1:ncolours){
    rect(xlefts[i],ybottoms[i],xrights[i],ytops[i],col=tempcol[i],border=NA)
  }
  if (labels){
    text((x=xleft+xright)/2, y=ybottom, var.min.label,adj=c(0.5,0),col=legend.text.col,font=2,cex=0.8)
    text((x=xleft+xright)/2, y=ytop, var.max.label,adj=c(0.5,1),col=legend.text.col,font=2,cex=0.8)
  }
}

#' Draws climate stripes given a time vector and environmental (usually temperature) vector
#'
#' @param time.vector the time series vector
#' @param temperature.vector a times series of any environmental variable (climate stripes have been developed for temperature) whose values correspond to the time vector
#' @param col1 the colour for the lowest values of the temperature vector
#' @param col2 the colour for the highest values of the temperature vector. A gradient between col1 and col2 is drawn for the other colours
#' @param title a title for the colour stripes plot if you want one
#' @param time.scale show a temporal axis. Default TRUE
#' @param legend puts a legend for the colour gradient on the top right of the plot with the lowest and highest values shown. Default TRUE
#' @param legend.text.col colour of the legend text
#' @param ... additional arguments that plot will accept, see par
#' @description Climate stripes are a simple way of showing how temperature (or any other time series) has changed over time. They are usually
#'       drawn for a temperature time series with blue being the coldest years and red being the warmest. They offer a relatively uncluttered
#'       depiction of a temperature over time that can be grasped almost immediately and are good at showing climate change from long time series.
#' @details This plot will always use both end of the colour series provided. So if your colours were blue and red and you had a two years times series
#'       then one stripe will be blue and the other red. i.e. the plots are meant to show changes not absolutes. This is a good reason why a legend
#'       might be excluded. They are usually not for communication to scienific audiences unless in as a quick slide in a presentation so consider
#'       not cluttering up the image with a legend and perhaps not even an axis.
#'
#'       Missing points in the time series should be NA for the variable. They are depicted as white spaces on the climate stripes plot. You will not
#'       get an error with missing points in the time series but it will show the stipes of the preceeding time series point to be wider. It is also
#'       deceptive to not include missing data.
#' @seealso plot par rect colour.gradient.legend.f
#' @references
#'       https://www.climate-lab-book.ac.uk/2018/warming-stripes/
#' @export
climate.col.stripes.f= function(time.vector,temperature.vector, col1="blue", col2="red", title="", time.scale=T, legend=T, legend.text.col, ...){

  temperature.vector= temperature.vector[-length(temperature.vector)]

  time.start= time.vector[-length(time.vector)]
  time.end= time.vector[-1]

    # dummy variables ot setup the plotting space
  x.dummy= c(time.vector[1], time.vector[length(time.vector)]+length(time.vector)*0.04)
  y.dummy= c(0,1)
  #par(mar=c(2,0.5,2,5))
  plot(x.dummy,y.dummy,axes=F,xlab="",ylab="",,type="n", ...)

    #colours need to be assigned to temperature in rank orde of temperature
  temperature.order= order(temperature.vector)
  tempcol=colorRampPalette(c(col1,col2))(length(temperature.vector))[temperature.order]
    # NA years are assigned the colour "white" or whatever you want
  tempcol[is.na(temperature.vector)]="white"

  rect(time.start,0,time.end,1,col=tempcol)
  if(time.scale) axis(1,at=time.vector,tick=F,line=-1)
  title(title,cex.main=.8)

  if(legend){
    colour.gradient.legend.f(xleft=max(time.vector)+length(time.vector)*0.02,
      ybottom=.5,
      xright=max(time.vector)+length(time.vector)*0.07,
      ytop=1,
      var.min.label=round(min(temperature.vector,na.rm=T),1),
      var.max.label=round(max(temperature.vector,na.rm=T),1),
      col1=col1, col2=col2,labels=T,legend.text.col=legend.text.col)
  }
}


# do a global plot bare
# do a global plot with axis, legend, title
# do a local plot all dressed
# do a global multiplot by month, no legend
# find a way to automatically access a lot of datasets