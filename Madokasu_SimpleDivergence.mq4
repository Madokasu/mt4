//+------------------------------------------------------------------+
//|                                              MACD_divergence.mq4 |
//|                                                          k-matsu |
//|                               http://www.age.jp/~k-matsu/FX/MT4/ |
//+------------------------------------------------------------------+
#property copyright "k-matsu"
#property link      "http://www.age.jp/~k-matsu/FX/MT4/"

#property indicator_separate_window
#property indicator_buffers 4
#property indicator_color1 Green
#property indicator_color2 Red
#property indicator_color3 Aqua
#property indicator_color4 Red
#property  indicator_width1  2
#property  indicator_width2  2
#property  indicator_width3  1
#property  indicator_width4  1

//---- input parameters
extern int       FastEMAPeriod=12;
extern int       SlowEMAPeriod=26;
extern int       SignalSMAPeriod=9;
extern int       SwingMargin=7;
extern int       HistgramType=1;
extern bool      MACD_Divergence=true;
extern bool      Histgram_Divergence=true;
extern bool      PeakConvergence=false;
extern bool      TroughDivergence=false;
extern int       MACDMargin=3;
extern int       HistgramMargin=3;
extern color     DivergenceColor=Red;
extern color     ConvergenceColor=Aqua;
extern bool      GuideLine=true;
extern color     GuidePeakColor=Aqua;
extern color     GuideTroughColor=Red;
extern int       GuidePeakStyle=STYLE_DOT;
extern int       GuideTroughStyle=STYLE_DOT;
extern bool      UseMacdMail=false;//Use E-Mail by Macd
extern bool      UseHistgramMail=false;//Use E-Mail by Histgram
//---- buffers
double MACDHistBufferPlus[];
double MACDHistBufferMinus[];
double MACDBuffer[];
double SignalBuffer[];
double MACDHistBuffer[];
double PeakBuffer[];
double TroughBuffer[];
//---- indicator name
string shortname_base="MACD_div";
string shortname;
//----

int MacdLastTime;
int HistgramLastTime;

int JapanDay,JapanDayOfWeek;
int JapanMonth,JapanHour,JapanMinute;
int AddJapanHour=7;
int AddJapanMinute=0;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
// sweep lines
   deinit();

   MacdLastTime=TimeHour(Time[0])*100+TimeMinute(Time[0]);
   HistgramLastTime=TimeHour(Time[0])*100+TimeMinute(Time[0]);

//---- indicators
   IndicatorBuffers(7);
   SetIndexStyle(0,DRAW_HISTOGRAM,STYLE_SOLID);
   SetIndexBuffer(0,MACDHistBufferPlus);
   SetIndexStyle(1,DRAW_HISTOGRAM,STYLE_SOLID);
   SetIndexBuffer(1,MACDHistBufferMinus);
   SetIndexStyle(2,DRAW_LINE);
   SetIndexBuffer(2,MACDBuffer);
   SetIndexLabel(2,StringConcatenate("MACD(",FastEMAPeriod,",",SlowEMAPeriod,")"));
   SetIndexStyle(3,DRAW_LINE);
   SetIndexBuffer(3,SignalBuffer);
   SetIndexLabel(3,StringConcatenate("MACD Signal(",SignalSMAPeriod,")"));
   SetIndexBuffer(4,MACDHistBuffer);
   SetIndexBuffer(5,PeakBuffer);
   SetIndexBuffer(6,TroughBuffer);

   shortname=StringConcatenate(shortname_base," (",FastEMAPeriod,",",SlowEMAPeriod,",",SignalSMAPeriod,")");
   IndicatorShortName(shortname);

// parameter check
   if(FastEMAPeriod < 1) FastEMAPeriod = 1;
   if(SlowEMAPeriod < 1) SlowEMAPeriod = 1;
   if(SlowEMAPeriod<=FastEMAPeriod) SlowEMAPeriod=FastEMAPeriod+1;
   if(SignalSMAPeriod<1) SignalSMAPeriod=1;
   if(HistgramType < 0) HistgramType = 0;
   if(HistgramType > 1) HistgramType = 1;
   if(SwingMargin<1) SwingMargin=1;
   if(MACDMargin<0) MACDMargin=0;
   if(MACDMargin>=SwingMargin) MACDMargin=SwingMargin-1;
   if(HistgramMargin<0) HistgramMargin=0;
   if(HistgramMargin>=SwingMargin) HistgramMargin=SwingMargin-1;
   if(GuidePeakStyle < 0) GuidePeakStyle = 0;
   if(GuidePeakStyle > 4) GuidePeakStyle = 4;
   if(GuideTroughStyle < 0) GuideTroughStyle = 0;
   if(GuideTroughStyle > 4) GuideTroughStyle = 4;
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   int shortname_length=StringLen(shortname);
   for(int i=ObjectsTotal()-1; i>=0; i--) 
     {
      string label=ObjectName(i);
      if(StringSubstr(label,0,shortname_length)==shortname)
         ObjectDelete(label);
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int limit,limitbase,limitMACD;
   int counted_bars=IndicatorCounted();
   if(counted_bars>0) counted_bars--;
   int prevpeakidx,prevtroughidx;
   int MACDidx,prevMACDidx,Histidx,prevHistidx;
   bool found=false;
   datetime peaktime,prevpeaktime,troughtime,prevtroughtime;
   datetime MACDtime,prevMACDtime,Histtime,prevHisttime;
   int window=WindowOnDropped();

   limitbase =Bars - counted_bars;
   for(int i=limitbase; i>=0; i--) 
     {
      PeakBuffer[i]=EMPTY_VALUE;
      TroughBuffer[i]=EMPTY_VALUE;
      MACDBuffer[i]=iMACD(NULL,0,FastEMAPeriod,SlowEMAPeriod,SignalSMAPeriod,PRICE_CLOSE,MODE_MAIN,i);
      SignalBuffer[i]=iMACD(NULL,0,FastEMAPeriod,SlowEMAPeriod,SignalSMAPeriod,PRICE_CLOSE,MODE_SIGNAL,i);
      MACDHistBuffer[i]=MACDBuffer[i]-SignalBuffer[i];
      MACDHistBufferPlus[i]=EMPTY_VALUE;
      MACDHistBufferMinus[i]=EMPTY_VALUE;
     }

   if(HistgramType==1) 
     {
      if(limitbase==Bars-1) 
        {
         MACDHistBufferPlus[i]=MACDHistBuffer[i];
         limitbase--;
        }
      for(i=limitbase; i>=0; i--) 
        {
         if(MACDHistBuffer[i]-MACDHistBuffer[i+1]>=0) 
           {
            MACDHistBufferPlus[i]=MACDHistBuffer[i];
              } else {
            MACDHistBufferMinus[i]=MACDHistBuffer[i];
           }
        }
      limitbase++;
        } else {
      for(i=limitbase; i>=0; i--) 
        {
         if(MACDHistBuffer[i]>= 0) 
           {
            MACDHistBufferPlus[i]=MACDHistBuffer[i];
              } else {
            MACDHistBufferMinus[i]=MACDHistBuffer[i];
           }
        }
     }

// search peak and divergence
   bool result;
   prevpeakidx=1; prevMACDidx=0; prevHistidx=0; limitMACD=Bars-MathMax(SlowEMAPeriod+SignalSMAPeriod,SwingMargin);
   for(limit=3; limit<limitMACD && PeakBuffer[limit]==EMPTY_VALUE; limit++) {}
   if(limit>SwingMargin) 
     {
      for(i=2; i<limit && High[i]==High[1]; i++) {}
      if(High[i]<High[1]) 
        {
         i=searchNextTroughIdx(MODE_HIGH,i,limit,1)+1;
        }
      while(i<limit) 
        {
         found=false;
         i=searchNextPeakIdx(MODE_HIGH,i,limit,SwingMargin);
         if(i - prevpeakidx >= SwingMargin) 
           {
            if(PeakBuffer[i] == EMPTY_VALUE) 
              {
               if(iHighest(NULL,0,MODE_HIGH,SwingMargin*2+1,i-SwingMargin)==i) 
                 {
                  found=true;
                  PeakBuffer[i]=High[i];
                 }
                 } else {
               found=true;
              }
            if(found) 
              {
               peaktime=Time[i];
               if(MACD_Divergence) 
                 {
                  MACDidx = ArrayMaximum(MACDBuffer, MACDMargin*2+1, i-MACDMargin);
                  MACDtime=Time[MACDidx];
                  if(prevMACDidx>0) 
                    {
                     prevpeaktime=Time[prevpeakidx];
                     prevMACDtime=Time[prevMACDidx];
                     if(High[i]<High[prevpeakidx] && MACDBuffer[MACDidx]>MACDBuffer[prevMACDidx]) 
                       {
                        //divergence!
                        createLine(StringConcatenate("pr1",peaktime,",",prevpeaktime),0,peaktime,High[i],prevpeaktime,High[prevpeakidx],DivergenceColor);
                        createLine(StringConcatenate("MACD",MACDtime,",",prevMACDtime),window,MACDtime,MACDBuffer[MACDidx],prevMACDtime,MACDBuffer[prevMACDidx],DivergenceColor);
                       }
                     if(PeakConvergence) 
                       {
                        if(High[i]>High[prevpeakidx] && MACDBuffer[MACDidx]<MACDBuffer[prevMACDidx]) 
                          {
                           //peak convergence!
                           createLine(StringConcatenate("pr1",peaktime,",",prevpeaktime),0,peaktime,High[i],prevpeaktime,High[prevpeakidx],ConvergenceColor);
                           createLine(StringConcatenate("MACD",MACDtime,",",prevMACDtime),window,MACDtime,MACDBuffer[MACDidx],prevMACDtime,MACDBuffer[prevMACDidx],ConvergenceColor);
                          }
                       }
                    }
                 } // end of if (MACD_Divergence)
               if(Histgram_Divergence) 
                 {
                  Histidx = ArrayMaximum(MACDHistBuffer, HistgramMargin*2+1, i-HistgramMargin);
                  Histtime=Time[Histidx];
                  if(prevHistidx>0) 
                    {
                     prevpeaktime=Time[prevpeakidx];
                     prevHisttime=Time[prevHistidx];
                     if(High[i]<High[prevpeakidx] && MACDHistBuffer[Histidx]>MACDHistBuffer[prevHistidx]) 
                       {
                        //divergence!
                        createLine(StringConcatenate("pr1",peaktime,",",prevpeaktime),0,peaktime,High[i],prevpeaktime,High[prevpeakidx],DivergenceColor);
                        createLine(StringConcatenate("Hist",Histtime,",",prevHisttime),window,Histtime,MACDHistBuffer[Histidx],prevHisttime,MACDHistBuffer[prevHistidx],DivergenceColor);
                       }
                     if(PeakConvergence) 
                       {
                        if(High[i]>High[prevpeakidx] && MACDHistBuffer[Histidx]<MACDHistBuffer[prevHistidx]) 
                          {
                           //peak convergence!
                           createLine(StringConcatenate("pr1",peaktime,",",prevpeaktime),0,peaktime,High[i],prevpeaktime,High[prevpeakidx],ConvergenceColor);
                           createLine(StringConcatenate("Hist",Histtime,",",prevHisttime),window,Histtime,MACDHistBuffer[Histidx],prevHisttime,MACDHistBuffer[prevHistidx],ConvergenceColor);
                          }
                       }
                    }
                 } // end of if (Histgram_Divergence)
               if(GuideLine && prevMACDidx==0) 
                 {
                  createGuideLine("PricePeak",0,peaktime,High[i],GuidePeakColor,GuidePeakStyle);
                  if(MACD_Divergence) 
                    {
                     createGuideLine("MACDPeak",window,MACDtime,MACDBuffer[MACDidx],GuidePeakColor,GuidePeakStyle);
                    }
                  if(Histgram_Divergence) 
                    {
                     createGuideLine("MACDHistPeak",window,Histtime,MACDHistBuffer[Histidx],GuidePeakColor,GuidePeakStyle);
                    }
                 }
               prevpeakidx = i;
               prevMACDidx = MACDidx;
               prevHistidx = Histidx;
              } // end of if (found)
           } // end of if (i - prevpeakidx >= SwingMargin)
         i=searchNextTroughIdx(MODE_HIGH,i+1,limit,1);
         i++;
        } // while (i < limit)
     } // end of if (limit > SwingMargin)

// search trough and convergence
   prevtroughidx=1; prevMACDidx=0; prevHistidx=0; limitMACD=Bars-MathMax(SlowEMAPeriod+SignalSMAPeriod,SwingMargin);
   for(limit=3; limit<limitMACD && TroughBuffer[limit]==EMPTY_VALUE; limit++) {}
   if(limit>SwingMargin) 
     {
      for(i=2; i<limit && Low[i]==Low[1]; i++) {}
      if(Low[i]>Low[1]) 
        {
         i=searchNextPeakIdx(MODE_LOW,i,limit,1)+1;
        }
      while(i<limit) 
        {
         found=false;
         i=searchNextTroughIdx(MODE_LOW,i,limit,SwingMargin);
         if(i - prevtroughidx >= SwingMargin) 
           {
            if(TroughBuffer[i] == EMPTY_VALUE) 
              {
               if(iLowest(NULL,0,MODE_LOW,SwingMargin*2+1,i-SwingMargin)==i) 
                 {
                  found=true;
                  TroughBuffer[i]=Low[i];
                 }
                 } else {
               found=true;
              }
            if(found) 
              {
               troughtime=Time[i];
               if(MACD_Divergence) 
                 {
                  MACDidx = ArrayMinimum(MACDBuffer, MACDMargin*2+1, i-MACDMargin);
                  MACDtime=Time[MACDidx];
                  if(prevMACDidx>0) 
                    {
                     prevtroughtime=Time[prevtroughidx];
                     prevMACDtime=Time[prevMACDidx];
                     if(Low[i]>Low[prevtroughidx] && MACDBuffer[MACDidx]<MACDBuffer[prevMACDidx]) 
                       {
                        //convergence!
                        createLine(StringConcatenate("pr2",troughtime,",",prevtroughtime),0,troughtime,Low[i],prevtroughtime,Low[prevtroughidx],ConvergenceColor);
                        createLine(StringConcatenate("MACD",MACDtime+",",prevMACDtime),window,MACDtime,MACDBuffer[MACDidx],prevMACDtime,MACDBuffer[prevMACDidx],ConvergenceColor);
                       }
                     if(TroughDivergence) 
                       {
                        if(Low[i]<Low[prevtroughidx] && MACDBuffer[MACDidx]>MACDBuffer[prevMACDidx]) 
                          {
                           // trough dinvergence!
                           createLine(StringConcatenate("pr2",troughtime,",",prevtroughtime),0,troughtime,Low[i],prevtroughtime,Low[prevtroughidx],DivergenceColor);
                           createLine(StringConcatenate("MACD",MACDtime,",",prevMACDtime),window,MACDtime,MACDBuffer[MACDidx],prevMACDtime,MACDBuffer[prevMACDidx],DivergenceColor);
                          }
                       }
                    }
                 }
               if(Histgram_Divergence) 
                 {
                  Histidx = ArrayMinimum(MACDHistBuffer, MACDMargin*2+1, i-HistgramMargin);
                  Histtime=Time[Histidx];
                  if(prevHistidx>0) 
                    {
                     prevtroughtime=Time[prevtroughidx];
                     prevHisttime=Time[prevHistidx];
                     if(Low[i]>Low[prevtroughidx] && MACDHistBuffer[Histidx]<MACDHistBuffer[prevHistidx]) 
                       {
                        //convergence!
                        createLine(StringConcatenate("pr2",troughtime,",",prevtroughtime),0,troughtime,Low[i],prevtroughtime,Low[prevtroughidx],ConvergenceColor);
                        createLine(StringConcatenate("Hist",Histtime+",",prevHisttime),window,Histtime,MACDHistBuffer[Histidx],prevHisttime,MACDHistBuffer[prevHistidx],ConvergenceColor);
                       }
                     if(TroughDivergence) 
                       {
                        if(Low[i]<Low[prevtroughidx] && MACDHistBuffer[Histidx]>MACDHistBuffer[prevHistidx]) 
                          {
                           // trough dinvergence!
                           createLine(StringConcatenate("pr2",troughtime,",",prevtroughtime),0,troughtime,Low[i],prevtroughtime,Low[prevtroughidx],DivergenceColor);
                           createLine(StringConcatenate("Hist",Histtime,",",prevHisttime),window,Histtime,MACDHistBuffer[Histidx],prevHisttime,MACDHistBuffer[prevHistidx],DivergenceColor);
                          }
                       }
                    }
                 }
               if(GuideLine && prevMACDidx==0) 
                 {
                  createGuideLine("PriceTrough",0,troughtime,Low[i],GuideTroughColor,GuideTroughStyle);
                  if(MACD_Divergence) 
                    {
                     createGuideLine("MACDTrough",window,MACDtime,MACDBuffer[MACDidx],GuideTroughColor,GuideTroughStyle);
                     //send mail
                     if(UseMacdMail && MacdLastTime!=TimeHour(Time[0])*100+TimeMinute(Time[0])) 
                       {
                        JapanTimeFunction();
                        result=SendMail("["+Symbol()+"] "+"MACD Divergence! on "+PeriodToString(Period()),
                                        "検知時間(日本時間)"+IntegerToString(JapanMonth)+"/"+IntegerToString(JapanDay)+" "+IntegerToString(JapanHour)+":"+IntegerToString(JapanMinute));
                        MacdLastTime=TimeHour(Time[0])*100+TimeMinute(Time[0]);
                       }
                    }
                  if(Histgram_Divergence) 
                    {
                     createGuideLine("HistTrough",window,Histtime,MACDHistBuffer[Histidx],GuideTroughColor,GuideTroughStyle);
                     //send mail
                     if(UseHistgramMail && HistgramLastTime!=TimeHour(Time[0])*100+TimeMinute(Time[0])) 
                       {
                        JapanTimeFunction();
                        result=SendMail("["+Symbol()+"] "+"Histgram Divergence! on "+PeriodToString(Period()),
                                        "検知時間(日本時間)"+IntegerToString(JapanMonth)+"/"+IntegerToString(JapanDay)+" "+IntegerToString(JapanHour)+":"+IntegerToString(JapanMinute));
                        HistgramLastTime=TimeHour(Time[0])*100+TimeMinute(Time[0]);
                       }
                    }
                 }
               prevtroughidx=i;
               prevMACDidx = MACDidx;
               prevHistidx = Histidx;
              }
           }
         i=searchNextPeakIdx(MODE_LOW,i+1,limit,1);
         i++;
        }
     }

//----
   return(0);
  }
//+------------------------------------------------------------------+

// subfunction

// need call after searchNextTroughIdx
int searchNextPeakIdx(int mode,int startidx,int limit,int margin)
  {
   int retidx,nextstartidx=startidx,prevpeakidx=nextstartidx,count;

   count=margin*2+1;
   if(nextstartidx+count>limit) count=limit-nextstartidx+1;

   retidx=iHighest(NULL,0,mode,count,nextstartidx);
   while(retidx>prevpeakidx && retidx<limit) 
     {
      prevpeakidx=retidx;

      nextstartidx=prevpeakidx-margin;
      if(nextstartidx<=startidx) nextstartidx=startidx+1;

      count=margin*2+1;
      if(nextstartidx+count>=limit) count=limit-nextstartidx+1;

      retidx=iHighest(NULL,0,mode,count,nextstartidx);
     }

   return(retidx);
  }
// need call after searchNextPeakIdx
int searchNextTroughIdx(int mode,int startidx,int limit,int margin)
  {
   int retidx,nextstartidx=startidx,prevtroughidx=nextstartidx,count;

   count=margin*2+1;
   if(nextstartidx+count>limit) count=limit-nextstartidx+1;

   retidx=iLowest(NULL,0,mode,count,nextstartidx);
   while(retidx>prevtroughidx && retidx<limit) 
     {
      prevtroughidx=retidx;

      nextstartidx=prevtroughidx-margin;
      if(nextstartidx<=startidx) nextstartidx=startidx+1;

      count=margin*2+1;
      if(nextstartidx+count>=limit) count=limit-nextstartidx+1;

      retidx=iLowest(NULL,0,mode,count,nextstartidx);
     }

   return(retidx);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int createLine(string subname,int window,datetime time1,double price1,datetime time2,double price2,color linecolor)
  {
   string objectname=shortname+subname;
   if(ObjectFind(objectname)==-1) 
     {
      ObjectCreate(objectname,OBJ_TREND,window,time1,price1,time2,price2);
     }
   ObjectSet(objectname,OBJPROP_RAY,false);
   ObjectSet(objectname,OBJPROP_TIME1,time1);
   ObjectSet(objectname,OBJPROP_PRICE1,price1);
   ObjectSet(objectname,OBJPROP_TIME2,time2);
   ObjectSet(objectname,OBJPROP_PRICE2,price2);
   ObjectSet(objectname,OBJPROP_COLOR,linecolor);
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int createGuideLine(string subname,int window,datetime time,double price,color linecolor,int linestyle)
  {
   string objectname=shortname+subname;
   ObjectCreate(objectname,OBJ_TREND,window,time,price,Time[0],price);
   ObjectSet(objectname,OBJPROP_RAY,true);
   ObjectSet(objectname,OBJPROP_TIME1,time);
   ObjectSet(objectname,OBJPROP_PRICE1,price);
   ObjectSet(objectname,OBJPROP_TIME2,Time[0]);
   ObjectSet(objectname,OBJPROP_PRICE2,price);
   ObjectSet(objectname,OBJPROP_COLOR,linecolor);
   ObjectSet(objectname,OBJPROP_STYLE,linestyle);
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string PeriodToString(int period)
  {
   string value="";

   if(period==0)
     {
      period= Period();
     }

   switch(period)
     {
      case PERIOD_M1:  value = "1分足 (M1)";   break;
      case PERIOD_M5:  value = "5分足 (M5)";   break;
      case PERIOD_M15: value = "15分足 (M15)"; break;
      case PERIOD_M30: value = "30分足 (M30)"; break;
      case PERIOD_H1:  value = "1時間足 (H1)"; break;
      case PERIOD_H4:  value = "4時間足 (H4)"; break;
      case PERIOD_D1:  value = "日足 (D1)";    break;
      case PERIOD_W1:  value = "週足 (W1)";    break;
      case PERIOD_MN1: value = "月足 (MN1)";   break;
      default: break;
     }
   return(value);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JapanTimeFunction()
  {

   JapanHour=Hour()+AddJapanHour;
   JapanMinute=Minute()+AddJapanMinute;
   JapanDayOfWeek=DayOfWeek();
   JapanDay=Day();
   JapanMonth=Month();

   if(JapanMinute>59)
     {
      JapanMinute-=60;
      JapanHour++;
     }

   if(JapanHour>23) JapanHour-=24;

   if(60*(Hour()+AddJapanHour)+Minute()+AddJapanMinute>24*60)
     {
      JapanDay++;
      JapanDayOfWeek++;
      if(
         (Month() ==1 && JapanDay == 32) ||
         (Month() ==2 && JapanDay == 29 && MathMod(Year(),4) != 0) ||
         (Month() ==2 && JapanDay == 30 && MathMod(Year(),4) == 0) ||
         (Month() ==3 && JapanDay == 32) ||
         (Month() ==4 && JapanDay == 31) ||
         (Month() ==5 && JapanDay == 32) ||
         (Month() ==6 && JapanDay == 31) ||
         (Month() ==7 && JapanDay == 32) ||
         (Month() ==8 && JapanDay == 32) ||
         (Month() ==9 && JapanDay == 31) ||
         (Month() ==10&& JapanDay == 32) ||
         (Month() ==11&& JapanDay == 31) ||
         (Month() ==12&& JapanDay == 32)
         )
        {
         JapanDay=1;
         JapanMonth=Month()+1;
        }
      if(JapanDayOfWeek>=7) JapanDayOfWeek-=7;
     }
  }
//+------------------------------------------------------------------+
