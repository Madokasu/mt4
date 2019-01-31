//+------------------------------------------------------------------+
//|                                            Madokasu_Strength.mq4 |
//+------------------------------------------------------------------+

#property link      "https://madokasu-fx.blogspot.com"

#property indicator_separate_window
#property indicator_buffers 8
#property indicator_level1 100
#property indicator_level2 0
#property indicator_level3 -100
#property indicator_levelcolor LightSlateGray
#property indicator_color1 Lime
#property indicator_color2 DodgerBlue
#property indicator_color3 Red
#property indicator_color4 Yellow
#property indicator_color5 DeepPink
#property indicator_color6 DarkOrange
#property indicator_color7 MediumSpringGreen
#property indicator_color8 LightSkyBlue
#property indicator_width1 1
#property indicator_width2 1
#property indicator_width3 1
#property indicator_width4 1
#property indicator_width5 1
#property indicator_width6 1
#property indicator_width7 1
#property indicator_width8 1

//---- input parameters
extern string Start_Time="2019.01.01 22:59"; // report point (in it all indexes are 100%)
extern bool   Use_Start_Time=false;          // use a report point, otherwise take the closing prices of the week
extern bool   Auto_Detect_Pair=false;        // automatically determine the currency pair and display the corresponding indexes
extern bool   Diff_Indicators=false;         // read the difference of indexes / indicators in the "auto-detect" mode of the pair
extern bool   Reverse_Index=false;           // "flip" the index of the currency, standing in a pair of second
extern int    Applied_Price=0;               // price used: 0-CLOSE; 1-OPEN; 2-HIGH; 3-LOW; 4-MEDIAN; 5-TYPICAL; 6-WEIGHTED;
extern int    MA_Period=1;                   // averaging period for calculating the moving average
extern int    MA_Method=3;                   // averaging method: 0-MODE_SMA; 1-MODE_EMA; 2-MODE_SMMA; 3-MODE_LWMA
extern int    Select_Indicator=0;            // 0-currency indices without indicators; 1-CCI; 2-RSI; 3-Momentum; 4-MACD; 5-stochastic;
extern int    Period_Indicator=14;           // averaging period for calculating the indicator
extern int    Fast_EMA=12;                   // for MACD indicator
extern int    Slow_EMA=26;                   // for MACD indicator
extern int    K_Period=5;                    // for stochastic indicator
extern int    Slowing=3;                     // for stochastic indicator
extern int    Limit_Bars=1000;               // The limit on the number of bars in the calculation.
extern bool   Show_USD=true;
extern bool   Show_EUR=true;
extern bool   Show_GBP=true;
extern bool   Show_JPY=true;
extern bool   Show_CHF=true;
extern bool   Show_AUD=true;
extern bool   Show_CAD=true;
extern bool   Show_NZD=true;
//---- buffers
double iUSDBuffer[];
double iEURBuffer[];
double iGBPBuffer[];
double iJPYBuffer[];
double iCHFBuffer[];
double iAUDBuffer[];
double iCADBuffer[];
double iNZDBuffer[];
double xUSDBuffer[];
double xEURBuffer[];
double xGBPBuffer[];
double xJPYBuffer[];
double xCHFBuffer[];
double xAUDBuffer[];
double xCADBuffer[];
double xNZDBuffer[];
//---- indicator buffers
double USDBuffer[];
double EURBuffer[];
double GBPBuffer[];
double JPYBuffer[];
double CHFBuffer[];
double AUDBuffer[];
double CADBuffer[];
double NZDBuffer[];
//---- indicator parameters
int      BarsCS,LB;
bool     Show_CUR[8],Stop=false;
double   SPrice[7];
string   CS1,CS2;
string   Currency[8]={"USD","EUR","GBP","JPY","CHF","AUD","CAD","NZD"};
int   colors_ary[8]={Lime, DodgerBlue, Red, Yellow, DeepPink, DarkOrange, MediumSpringGreen, LightSkyBlue};
string   Symbols[7]={"AUDUSD","EURUSD","GBPUSD","NZDUSD","USDCAD","USDCHF","USDJPY"};
datetime Period_End,SPoint;
bool time_initialized=false;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   int i;
   bool    show=false;
   string  name;
   time_initialized=false;
   Comment("");
   if(Period()==PERIOD_MN1)
     {
      Comment("The period can not be longer than W1");
      Stop=true;
      return(-1);
     }
   if(Auto_Detect_Pair)
     {
      ArrayInitialize(Show_CUR,false);
      CS1=StringSubstr(Symbol(),0,3);
      CS2=StringSubstr(Symbol(),3,3);
      for(i=0;i<8;i++)
        {
         if(Currency[i]==CS1 || Currency[i]==CS2)
           {
            Show_CUR[i]=true;
            show=true;
           }
        }
      if(!show)
        {
         ArrayInitialize(Show_CUR,true);
         Comment("No index corresponds to this tool.");
        }
     }
   else
     {
      Show_CUR[0]=Show_USD;
      Show_CUR[1]=Show_EUR;
      Show_CUR[2]=Show_GBP;
      Show_CUR[3]=Show_JPY;
      Show_CUR[4]=Show_CHF;
      Show_CUR[5]=Show_AUD;
      Show_CUR[6]=Show_CAD;
      Show_CUR[7]=Show_NZD;
     }

   if(Use_Start_Time)
     {
      Period_End=StrToTime(Start_Time);
      if(Period_End<SPoint)
        {
         Period_End=SPoint+60*Period()*(Period_Indicator+1);
         Comment("Another report point selected - "+TimeToStr(Period_End));
        }
     }
   else
     {
      i=0;
      while((iTime(NULL,0,i+1)+172800)>iTime(NULL,0,i)) i++;
      Period_End=iTime(NULL,0,i+1);
     }
   if(Applied_Price<0) Applied_Price=0;
   if(Applied_Price>6) Applied_Price=6;
   for(i=0;i<7;i++) SPrice[i]=Price(i,Period_End);
   name="Indexes( ";
   for(i=0;i<8;i++) if(Show_CUR[i])
     {
      switch(i)
        {
         case 0: {SetIndexBuffer(0,USDBuffer); ArraySetAsSeries(iUSDBuffer,true); ArraySetAsSeries(xUSDBuffer,true);} break;
         case 1: {SetIndexBuffer(1,EURBuffer); ArraySetAsSeries(iEURBuffer,true); ArraySetAsSeries(xEURBuffer,true);} break;
         case 2: {SetIndexBuffer(2,GBPBuffer); ArraySetAsSeries(iGBPBuffer,true); ArraySetAsSeries(xGBPBuffer,true);} break;
         case 3: {SetIndexBuffer(3,JPYBuffer); ArraySetAsSeries(iJPYBuffer,true); ArraySetAsSeries(xJPYBuffer,true);} break;
         case 4: {SetIndexBuffer(4,CHFBuffer); ArraySetAsSeries(iCHFBuffer,true); ArraySetAsSeries(xCHFBuffer,true);} break;
         case 5: {SetIndexBuffer(5,AUDBuffer); ArraySetAsSeries(iAUDBuffer,true); ArraySetAsSeries(xAUDBuffer,true);} break;
         case 6: {SetIndexBuffer(6,CADBuffer); ArraySetAsSeries(iCADBuffer,true); ArraySetAsSeries(xCADBuffer,true);} break;
         case 7: {SetIndexBuffer(7,NZDBuffer); ArraySetAsSeries(iNZDBuffer,true); ArraySetAsSeries(xNZDBuffer,true);}
        }
      SetIndexStyle(i,DRAW_LINE);
      if(Reverse_Index && Currency[i]==CS2) SetIndexLabel(i,Currency[i]+" reverse");
      else SetIndexLabel(i,Currency[i]);
      name=StringConcatenate(name,Currency[i]," ");
     }
   name=name+")";
   if(MA_Period<1) MA_Period=1;
   if(MA_Method<0) MA_Method=0;
   if(MA_Method>3) MA_Method=3;
   if(Select_Indicator<0) Select_Indicator=0;
   if(Select_Indicator>5) Select_Indicator=5;
   if(Period_Indicator<1) Period_Indicator=1;
   if(Limit_Bars<1) Limit_Bars=1;
   Limit_Bars+=Period_Indicator;
   switch(Select_Indicator)
     {
      case 1: name=StringConcatenate(name,"+CCI(",Period_Indicator,")"); break;
      case 2: name=StringConcatenate(name,"+RSI(",Period_Indicator,")"); break;
      case 3: name=StringConcatenate(name,"+Mom.(",Period_Indicator,")"); break;
      case 4: name=StringConcatenate(name,"+MACD(",Fast_EMA,",",Slow_EMA,")"); break;
      case 5: name=StringConcatenate(name,"+St.(",K_Period,",",Slowing,")");
     }
   name=StringConcatenate(name,"+MA(",MA_Period,",",MA_Method,")");
   if(Diff_Indicators && Auto_Detect_Pair) name=StringConcatenate(name,"+diff");
   IndicatorDigits(2);
   IndicatorShortName(name);

   for(int _idx=0; _idx<8; _idx++)
     {
      string ChartInfo="Strength_Label_"+DoubleToStr(_idx,0);
      ObjectCreate(ChartInfo,OBJ_LABEL,0,0,0);
      ObjectSetText(ChartInfo,"----- "+Currency[_idx],9,"Arial",colors_ary[_idx]);
      ObjectSet(ChartInfo,OBJPROP_CORNER,0);
      ObjectSet(ChartInfo,OBJPROP_XDISTANCE,8);
      ObjectSet(ChartInfo,OBJPROP_YDISTANCE,_idx*20+20);
     }

   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool sTimeInitialize()
  {
   int     i,sbar,stime[8];
//---
   for(i=0;i<7;i++)
     {
      sbar=iBars(Symbols[i],0);
      if(sbar==0)
        {
         Comment("There is no history for "+Symbols[i]);
         Print("There is no history for "+Symbols[i]);
         Stop=true;
         return(false);
        }
      stime[i]=iTime(Symbols[i],0,sbar-1);
     }
   sbar=iBars(NULL,0);
   stime[7]=iTime(NULL,0,sbar-1);
   SPoint=stime[ArrayMaximum(stime)];
   BarsCS=iBarShift(NULL,0,SPoint);
   return(true);
  }
//+----------------------------------------------------------------------------+
//|  Custom indicator deinitialization function                                |
//+----------------------------------------------------------------------------+
int deinit()
  {
   ObjectDelete("Period_End");
   return(0);
  }
//+------------------------------------------------------------------+
//| Indexes foreign exchange                                         |
//+------------------------------------------------------------------+
int start()
  {
   int      i,b,c,limit;
   double   curbuffer,change,cindex[8];
   datetime btime,ltime;
   static datetime timebar;

   if(Stop) return(-1);
   if(!time_initialized)
     {
      time_initialized=sTimeInitialize();
      if(!time_initialized)
        {
         Print("Not  all symbols are ready for calculations. Exiting from start()");
         return(0);
        }
      else
        {
         Print("Ready for calculations on ",BarsCS," bars from ",SPoint);
        }
     }

   if(timebar!=Time[0])
     {
      timebar=Time[0];
      BarsCS=iBarShift(NULL,0,SPoint);
      if(BarsCS<10) return(0);
      if(BarsCS>Limit_Bars) BarsCS=Limit_Bars;
      if(Show_CUR[0]) {ArrayResize(iUSDBuffer,BarsCS+1); ArrayResize(xUSDBuffer,BarsCS-Period_Indicator+1);}
      if(Show_CUR[1]) {ArrayResize(iEURBuffer,BarsCS+1); ArrayResize(xEURBuffer,BarsCS-Period_Indicator+1);}
      if(Show_CUR[2]) {ArrayResize(iGBPBuffer,BarsCS+1); ArrayResize(xGBPBuffer,BarsCS-Period_Indicator+1);}
      if(Show_CUR[3]) {ArrayResize(iJPYBuffer,BarsCS+1); ArrayResize(xJPYBuffer,BarsCS-Period_Indicator+1);}
      if(Show_CUR[4]) {ArrayResize(iCHFBuffer,BarsCS+1); ArrayResize(xCHFBuffer,BarsCS-Period_Indicator+1);}
      if(Show_CUR[5]) {ArrayResize(iAUDBuffer,BarsCS+1); ArrayResize(xAUDBuffer,BarsCS-Period_Indicator+1);}
      if(Show_CUR[6]) {ArrayResize(iCADBuffer,BarsCS+1); ArrayResize(xCADBuffer,BarsCS-Period_Indicator+1);}
      if(Show_CUR[7]) {ArrayResize(iNZDBuffer,BarsCS+1); ArrayResize(xNZDBuffer,BarsCS-Period_Indicator+1);}
      for(i=BarsCS;i>0;i--)
        {
         if(Show_CUR[0]) iUSDBuffer[i]=iUSDBuffer[i-1];
         if(Show_CUR[1]) iEURBuffer[i]=iEURBuffer[i-1];
         if(Show_CUR[2]) iGBPBuffer[i]=iGBPBuffer[i-1];
         if(Show_CUR[3]) iJPYBuffer[i]=iJPYBuffer[i-1];
         if(Show_CUR[4]) iCHFBuffer[i]=iCHFBuffer[i-1];
         if(Show_CUR[5]) iAUDBuffer[i]=iAUDBuffer[i-1];
         if(Show_CUR[6]) iCADBuffer[i]=iCADBuffer[i-1];
         if(Show_CUR[7]) iNZDBuffer[i]=iNZDBuffer[i-1];
        }
      for(i=BarsCS-Period_Indicator;i>0;i--)
        {
         if(Show_CUR[0]) xUSDBuffer[i]=xUSDBuffer[i-1];
         if(Show_CUR[1]) xEURBuffer[i]=xEURBuffer[i-1];
         if(Show_CUR[2]) xGBPBuffer[i]=xGBPBuffer[i-1];
         if(Show_CUR[3]) xJPYBuffer[i]=xJPYBuffer[i-1];
         if(Show_CUR[4]) xCHFBuffer[i]=xCHFBuffer[i-1];
         if(Show_CUR[5]) xAUDBuffer[i]=xAUDBuffer[i-1];
         if(Show_CUR[6]) xCADBuffer[i]=xCADBuffer[i-1];
         if(Show_CUR[7]) xNZDBuffer[i]=xNZDBuffer[i-1];
        }
     }
   if(ObjectFind("Period_End")==-1)
     {
      Print("Creating vertical line \"Period_End\"");
      ObjectCreate("Period_End",OBJ_VLINE,0,Period_End,0);
      ObjectSetText("Period_End","Report point");
      ObjectSet("Period_End",OBJPROP_COLOR,OrangeRed);
      ObjectSet("Period_End",OBJPROP_WIDTH,2);
     }
   if(Period_End!=ObjectGet("Period_End",OBJPROP_TIME1))
     {
      Period_End=ObjectGet("Period_End",OBJPROP_TIME1);
      for(i=0;i<7;i++) SPrice[i]=Price(i,Period_End);
      LB=BarsCS;
     }
   LB=BarsCS;
   int counted_bars=IndicatorCounted();
   if(Bars-counted_bars>LB) limit=LB;
   for(b=limit;b>=0;b--)
     {
      ArrayInitialize(cindex,1.0);
      btime=iTime(NULL,0,b);
      //dollar index calculation
      for(i=0;i<7;i++)
        {
         change=Price(i,btime)/SPrice[i];
         if(StringSubstr(Symbols[i],0,3)==Currency[0]) cindex[0]*=change;
         if(StringSubstr(Symbols[i],3,3)==Currency[0]) cindex[0]/=change;
        }
      cindex[0]=100*MathPow(cindex[0],0.125);
      if(Show_CUR[1]) cindex[1]=cindex[0]*(Price(1,btime)/SPrice[1]);
      if(Show_CUR[2]) cindex[2]=cindex[0]*(Price(2,btime)/SPrice[2]);
      if(Show_CUR[3]) cindex[3]=cindex[0]/(Price(6,btime)/SPrice[6]);
      if(Show_CUR[4]) cindex[4]=cindex[0]/(Price(5,btime)/SPrice[5]);
      if(Show_CUR[5]) cindex[5]=cindex[0]*(Price(0,btime)/SPrice[0]);
      if(Show_CUR[6]) cindex[6]=cindex[0]/(Price(4,btime)/SPrice[4]);
      if(Show_CUR[7]) cindex[7]=cindex[0]*(Price(3,btime)/SPrice[3]);
      if(Reverse_Index)
         for(c=0;c<8;c++)
           {
            if(Show_CUR[c] && Currency[c]==CS2) cindex[c]=200-cindex[c];
           }
      //PrintFormat("b=%d  ArraySize(iEURBuffer)=%d",b,ArraySize(iEURBuffer));
      if(Show_CUR[0]) iUSDBuffer[b]=cindex[0];
      if(Show_CUR[1]) iEURBuffer[b]=cindex[1];
      if(Show_CUR[2]) iGBPBuffer[b]=cindex[2];
      if(Show_CUR[3]) iJPYBuffer[b]=cindex[3];
      if(Show_CUR[4]) iCHFBuffer[b]=cindex[4];
      if(Show_CUR[5]) iAUDBuffer[b]=cindex[5];
      if(Show_CUR[6]) iCADBuffer[b]=cindex[6];
      if(Show_CUR[7]) iNZDBuffer[b]=cindex[7];
     }
   if(limit>(BarsCS-Period_Indicator)) limit=BarsCS-Period_Indicator;
   for(b=limit;b>=0;b--)
     {
      switch(Select_Indicator)
        {
         case 0:
           {
            if(Show_CUR[0]) xUSDBuffer[b]=iUSDBuffer[b];
            if(Show_CUR[1]) xEURBuffer[b]=iEURBuffer[b];
            if(Show_CUR[2]) xGBPBuffer[b]=iGBPBuffer[b];
            if(Show_CUR[3]) xJPYBuffer[b]=iJPYBuffer[b];
            if(Show_CUR[4]) xCHFBuffer[b]=iCHFBuffer[b];
            if(Show_CUR[5]) xAUDBuffer[b]=iAUDBuffer[b];
            if(Show_CUR[6]) xCADBuffer[b]=iCADBuffer[b];
            if(Show_CUR[7]) xNZDBuffer[b]=iNZDBuffer[b];
           }
         break;
         case 1:
           {
            if(Show_CUR[0]) xUSDBuffer[b]=iCCIOnArray(iUSDBuffer,0,Period_Indicator,b);
            if(Show_CUR[1]) xEURBuffer[b]=iCCIOnArray(iEURBuffer,0,Period_Indicator,b);
            if(Show_CUR[2]) xGBPBuffer[b]=iCCIOnArray(iGBPBuffer,0,Period_Indicator,b);
            if(Show_CUR[3]) xJPYBuffer[b]=iCCIOnArray(iJPYBuffer,0,Period_Indicator,b);
            if(Show_CUR[4]) xCHFBuffer[b]=iCCIOnArray(iCHFBuffer,0,Period_Indicator,b);
            if(Show_CUR[5]) xAUDBuffer[b]=iCCIOnArray(iAUDBuffer,0,Period_Indicator,b);
            if(Show_CUR[6]) xCADBuffer[b]=iCCIOnArray(iCADBuffer,0,Period_Indicator,b);
            if(Show_CUR[7]) xNZDBuffer[b]=iCCIOnArray(iNZDBuffer,0,Period_Indicator,b);
           }
         break;
         case 2:
           {
            if(Show_CUR[0]) xUSDBuffer[b]=iRSIOnArray(iUSDBuffer,0,Period_Indicator,b);
            if(Show_CUR[1]) xEURBuffer[b]=iRSIOnArray(iEURBuffer,0,Period_Indicator,b);
            if(Show_CUR[2]) xGBPBuffer[b]=iRSIOnArray(iGBPBuffer,0,Period_Indicator,b);
            if(Show_CUR[3]) xJPYBuffer[b]=iRSIOnArray(iJPYBuffer,0,Period_Indicator,b);
            if(Show_CUR[4]) xCHFBuffer[b]=iRSIOnArray(iCHFBuffer,0,Period_Indicator,b);
            if(Show_CUR[5]) xAUDBuffer[b]=iRSIOnArray(iAUDBuffer,0,Period_Indicator,b);
            if(Show_CUR[6]) xCADBuffer[b]=iRSIOnArray(iCADBuffer,0,Period_Indicator,b);
            if(Show_CUR[7]) xNZDBuffer[b]=iRSIOnArray(iNZDBuffer,0,Period_Indicator,b);
           }
         break;
         case 3:
           {
            if(Show_CUR[0]) xUSDBuffer[b]=iMomentumOnArray(iUSDBuffer,0,Period_Indicator,b);
            if(Show_CUR[1]) xEURBuffer[b]=iMomentumOnArray(iEURBuffer,0,Period_Indicator,b);
            if(Show_CUR[2]) xGBPBuffer[b]=iMomentumOnArray(iGBPBuffer,0,Period_Indicator,b);
            if(Show_CUR[3]) xJPYBuffer[b]=iMomentumOnArray(iJPYBuffer,0,Period_Indicator,b);
            if(Show_CUR[4]) xCHFBuffer[b]=iMomentumOnArray(iCHFBuffer,0,Period_Indicator,b);
            if(Show_CUR[5]) xAUDBuffer[b]=iMomentumOnArray(iAUDBuffer,0,Period_Indicator,b);
            if(Show_CUR[6]) xCADBuffer[b]=iMomentumOnArray(iCADBuffer,0,Period_Indicator,b);
            if(Show_CUR[7]) xNZDBuffer[b]=iMomentumOnArray(iNZDBuffer,0,Period_Indicator,b);
           }
         break;
         case 4:
           {
            if(Show_CUR[0]) xUSDBuffer[b]=iMAOnArray(iUSDBuffer,0,Fast_EMA,0,MODE_EMA,b)-iMAOnArray(iUSDBuffer,0,Slow_EMA,0,MODE_EMA,b);
            if(Show_CUR[1]) xEURBuffer[b]=iMAOnArray(iEURBuffer,0,Fast_EMA,0,MODE_EMA,b)-iMAOnArray(iEURBuffer,0,Slow_EMA,0,MODE_EMA,b);
            if(Show_CUR[2]) xGBPBuffer[b]=iMAOnArray(iGBPBuffer,0,Fast_EMA,0,MODE_EMA,b)-iMAOnArray(iGBPBuffer,0,Slow_EMA,0,MODE_EMA,b);
            if(Show_CUR[3]) xJPYBuffer[b]=iMAOnArray(iJPYBuffer,0,Fast_EMA,0,MODE_EMA,b)-iMAOnArray(iJPYBuffer,0,Slow_EMA,0,MODE_EMA,b);
            if(Show_CUR[4]) xCHFBuffer[b]=iMAOnArray(iCHFBuffer,0,Fast_EMA,0,MODE_EMA,b)-iMAOnArray(iCHFBuffer,0,Slow_EMA,0,MODE_EMA,b);
            if(Show_CUR[5]) xAUDBuffer[b]=iMAOnArray(iAUDBuffer,0,Fast_EMA,0,MODE_EMA,b)-iMAOnArray(iAUDBuffer,0,Slow_EMA,0,MODE_EMA,b);
            if(Show_CUR[6]) xCADBuffer[b]=iMAOnArray(iCADBuffer,0,Fast_EMA,0,MODE_EMA,b)-iMAOnArray(iCADBuffer,0,Slow_EMA,0,MODE_EMA,b);
            if(Show_CUR[7]) xNZDBuffer[b]=iMAOnArray(iNZDBuffer,0,Fast_EMA,0,MODE_EMA,b)-iMAOnArray(iNZDBuffer,0,Slow_EMA,0,MODE_EMA,b);
           }
         break;
         case 5:
           {
            if(Show_CUR[0]) xUSDBuffer[b]=Stochastic(b,iUSDBuffer);
            if(Show_CUR[1]) xEURBuffer[b]=Stochastic(b,iEURBuffer);
            if(Show_CUR[2]) xGBPBuffer[b]=Stochastic(b,iGBPBuffer);
            if(Show_CUR[3]) xJPYBuffer[b]=Stochastic(b,iJPYBuffer);
            if(Show_CUR[4]) xCHFBuffer[b]=Stochastic(b,iCHFBuffer);
            if(Show_CUR[5]) xAUDBuffer[b]=Stochastic(b,iAUDBuffer);
            if(Show_CUR[6]) xCADBuffer[b]=Stochastic(b,iCADBuffer);
            if(Show_CUR[7]) xNZDBuffer[b]=Stochastic(b,iNZDBuffer);
           }
        }
     }
   if(limit>(BarsCS-MA_Period-Period_Indicator)) limit-=MA_Period;
   for(b=limit;b>=0;b--)
     {
      if(Show_CUR[0]) USDBuffer[b]=NormalizeDouble(iMAOnArray(xUSDBuffer,0,MA_Period,0,MA_Method,b),3);
      if(Show_CUR[1]) EURBuffer[b]=NormalizeDouble(iMAOnArray(xEURBuffer,0,MA_Period,0,MA_Method,b),3);
      if(Show_CUR[2]) GBPBuffer[b]=NormalizeDouble(iMAOnArray(xGBPBuffer,0,MA_Period,0,MA_Method,b),3);
      if(Show_CUR[3]) JPYBuffer[b]=NormalizeDouble(iMAOnArray(xJPYBuffer,0,MA_Period,0,MA_Method,b),3);
      if(Show_CUR[4]) CHFBuffer[b]=NormalizeDouble(iMAOnArray(xCHFBuffer,0,MA_Period,0,MA_Method,b),3);
      if(Show_CUR[5]) AUDBuffer[b]=NormalizeDouble(iMAOnArray(xAUDBuffer,0,MA_Period,0,MA_Method,b),3);
      if(Show_CUR[6]) CADBuffer[b]=NormalizeDouble(iMAOnArray(xCADBuffer,0,MA_Period,0,MA_Method,b),3);
      if(Show_CUR[7]) NZDBuffer[b]=NormalizeDouble(iMAOnArray(xNZDBuffer,0,MA_Period,0,MA_Method,b),3);
      if(Diff_Indicators && Auto_Detect_Pair)
        {
         if(CS1==Currency[0]) {curbuffer=USDBuffer[b]; USDBuffer[b]=EMPTY_VALUE;}
         if(CS1==Currency[1]) {curbuffer=EURBuffer[b]; EURBuffer[b]=EMPTY_VALUE;}
         if(CS1==Currency[2]) {curbuffer=GBPBuffer[b]; GBPBuffer[b]=EMPTY_VALUE;}
         if(CS1==Currency[3]) {curbuffer=JPYBuffer[b]; JPYBuffer[b]=EMPTY_VALUE;}
         if(CS1==Currency[4]) {curbuffer=CHFBuffer[b]; CHFBuffer[b]=EMPTY_VALUE;}
         if(CS1==Currency[5]) {curbuffer=AUDBuffer[b]; AUDBuffer[b]=EMPTY_VALUE;}
         if(CS1==Currency[6]) {curbuffer=CADBuffer[b]; CADBuffer[b]=EMPTY_VALUE;}
         if(CS1==Currency[7]) {curbuffer=NZDBuffer[b]; NZDBuffer[b]=EMPTY_VALUE;}
         if(CS2==Currency[0]) USDBuffer[b]=curbuffer-USDBuffer[b];
         if(CS2==Currency[1]) EURBuffer[b]=curbuffer-EURBuffer[b];
         if(CS2==Currency[2]) GBPBuffer[b]=curbuffer-GBPBuffer[b];
         if(CS2==Currency[3]) JPYBuffer[b]=curbuffer-JPYBuffer[b];
         if(CS2==Currency[4]) CHFBuffer[b]=curbuffer-CHFBuffer[b];
         if(CS2==Currency[5]) AUDBuffer[b]=curbuffer-AUDBuffer[b];
         if(CS2==Currency[6]) CADBuffer[b]=curbuffer-CADBuffer[b];
         if(CS2==Currency[7]) NZDBuffer[b]=curbuffer-NZDBuffer[b];
        }
     }
   ltime=iTime(NULL,0,1);
   for(i=0;i<7;i++) if(iTime(Symbols[i],0,1)<ltime) ltime=iTime(Symbols[i],0,1);
   LB=iBarShift(NULL,0,ltime);
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double Price(int k,datetime time)
  {
   double price;
   int bar=iBarShift(Symbols[k],0,time);
   switch(Applied_Price)
     {
      case PRICE_CLOSE:    price=iClose(Symbols[k],0,bar); break;
      case PRICE_OPEN:     price=iOpen(Symbols[k],0,bar); break;
      case PRICE_HIGH:     price=iHigh(Symbols[k],0,bar); break;
      case PRICE_LOW:      price=iLow(Symbols[k],0,bar); break;
      case PRICE_MEDIAN:   price=(iHigh(Symbols[k],0,bar)+iLow(Symbols[k],0,bar))/2; break;
      case PRICE_TYPICAL:  price=(iHigh(Symbols[k],0,bar)+iLow(Symbols[k],0,bar)+iClose(Symbols[k],0,bar))/3; break;
      case PRICE_WEIGHTED: price=(iHigh(Symbols[k],0,bar)+iLow(Symbols[k],0,bar)+iClose(Symbols[k],0,bar)+iClose(Symbols[k],0,bar))/4;
     }
   return(price);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double Stochastic(int k,double &buffer[])
  {
   double max,min;
   double sum1=0.0;
   double sum2=0.0;
   for(int n=0;n<Slowing;n++)
     {
      max=buffer[ArrayMaximum(buffer,K_Period,k+n)];
      min=buffer[ArrayMinimum(buffer,K_Period,k+n)];
      sum1+=buffer[k+n]-min;
      sum2+=max-min;
     }
   if(sum2==0.0) return(100);
   else return(sum1/sum2*100);
  }
//+------------------------------------------------------------------+
