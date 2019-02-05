//+------------------------------------------------------------------+
//|                                         EMA-Crossover_Signal.mq4 |
//+------------------------------------------------------------------+

/*
  +------------------------------------------------------------------+
  | Allows you to enter two ema periods and it will then show you at |
  | Which point they crossed over. It is more usful on the shorter   |
  | periods that get obscured by the bars / candlesticks and when    |
  | the zoom level is out. Also allows you then to remove the emas   |
  | from the chart. (emas are initially set at 5 and 6)              |
  +------------------------------------------------------------------+
*/
#property link      "https://madokasu-fx.blogspot.com"

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 Green
#property indicator_color2 Red

double CrossUp[];
double CrossDown[];
double TestLine[];
extern int FasterEMA = 5;
extern int SlowerEMA = 6;
input bool   UseMail=false;//Use E-Mail

int LastTime;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   IndicatorBuffers(3);
   SetIndexStyle(0,DRAW_ARROW,0,2);
   SetIndexArrow(0,233);
   SetIndexBuffer(0,CrossUp);
   SetIndexStyle(1,DRAW_ARROW,0,2);
   SetIndexArrow(1,234);
   SetIndexBuffer(1,CrossDown);
   SetIndexBuffer(2,TestLine);
//----
   LastTime=TimeHour(Time[0])*100+TimeMinute(Time[0]);

   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----

//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start() 
  {
   int limit,i,counter;
   double fasterEMAnow,slowerEMAnow,fasterEMAprevious,slowerEMAprevious,fasterEMAafter,slowerEMAafter;
   double Range,AvgRange;
   int counted_bars=IndicatorCounted();

//---- check for possible errors
   if(counted_bars<0) return(-1);

//---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;

   limit=Bars-counted_bars;

   for(i=0; i<=limit; i++) 
     {

      counter=i;
      Range=0;
      AvgRange=0;
      for(counter=i;counter<=i+9;counter++)
        {
         AvgRange=AvgRange+MathAbs(High[counter]-Low[counter]);
        }
      Range=AvgRange/10;

      fasterEMAnow=iMA(NULL,0,FasterEMA,0,MODE_EMA,PRICE_CLOSE,i);
      fasterEMAprevious=iMA(NULL,0,FasterEMA,0,MODE_EMA,PRICE_CLOSE,i+1);
      fasterEMAafter=iMA(NULL,0,FasterEMA,0,MODE_EMA,PRICE_CLOSE,i-1);

      slowerEMAnow=iMA(NULL,0,SlowerEMA,0,MODE_EMA,PRICE_CLOSE,i);
      slowerEMAprevious=iMA(NULL,0,SlowerEMA,0,MODE_EMA,PRICE_CLOSE,i+1);
      slowerEMAafter=iMA(NULL,0,SlowerEMA,0,MODE_EMA,PRICE_CLOSE,i-1);

      string msg;
      if((fasterEMAnow>slowerEMAnow)
         && (fasterEMAprevious<slowerEMAprevious)
         && (fasterEMAafter>slowerEMAafter)) 
        {
         CrossUp[i]=Low[i]-Range*1.5;
         if(UseMail && LastTime!=TimeHour(Time[0])*100+TimeMinute(Time[0])) 
           {

            msg="["+Symbol()+"]"+" Long!! at "+DoubleToStr(Ask,Digits());
            SendMail(msg,msg);
            LastTime=TimeHour(Time[0])*100+TimeMinute(Time[0]);
           }
        }
      else if((fasterEMAnow<slowerEMAnow)
         && (fasterEMAprevious>slowerEMAprevious)
         && (fasterEMAafter<slowerEMAafter)) 
           {
            CrossDown[i]=High[i]+Range*1.5;
            if(UseMail && LastTime!=TimeHour(Time[0])*100+TimeMinute(Time[0])) 
              {
               msg="["+Symbol()+"]"+" Short!! at "+DoubleToStr(Bid,Digits());
               SendMail(msg,msg);
               LastTime=TimeHour(Time[0])*100+TimeMinute(Time[0]);
              }
           }
        }
      return(0);
     }
//+------------------------------------------------------------------+
