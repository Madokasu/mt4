//+------------------------------------------------------------------+
//|                                           Madokasu_CCI_Alert.mq4 |
//|                                                                  |
//+------------------------------------------------------------------+
#property link      "https://madokasu-fx.blogspot.com"
#property strict

#property indicator_separate_window
#property indicator_buffers 7
#property indicator_color1 Red
#property indicator_color2 Red
#property indicator_color3 Red
#property indicator_color4 Red
#property indicator_color5 Red
#property indicator_color6 Red
#property indicator_color7 Red
#property indicator_width1 2
#property indicator_width2 2
#property indicator_width3 2
#property indicator_width4 2
#property indicator_width5 2
#property indicator_width6 0
#property indicator_width7 0
#property  indicator_level1  0
#property indicator_level2  -100
#property  indicator_level3  100
#property indicator_level4  -200
#property  indicator_level5  200



//---- input parameters
extern int CCIPeriod                = 14;
extern int CCIPrice                 = 0;
extern int UpperTriggerLevel        = 100;
extern int LowerTriggerLevel        = -100;
extern int CriticalLevel            = 250;
extern bool HISTOGRAM               = false;
extern bool Alerts                  = false;
extern string CriticalLevelAlert    = "CCI Critical Level";
extern string ZeroBuyAlert          = "BUY CCI Zero Cross";
extern string ZeroSellAlert         = "SELL CCI Zero Cross";
extern string UpperTriggerBuyAlert  = "BUY CCI Upper Trigger Cross";
extern string UpperTriggerSellAlert = "SELL CCI Upper Trigger Cross";
extern string LowerTriggerBuyAlert  = "BUY CCI Lower Trigger Cross";
extern string LowerTriggerSellAlert = "SELL CCI Lower Trigger Cross";

//---- indicator buffers
double CCI[];
double UpBuffer1[];
double UpBuffer2[];
double DnBuffer1[];
double DnBuffer2[];
double DnArr[];
double UpArr[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init () {
  IndicatorBuffers (7);

  int DrawType = DRAW_LINE;
  if (HISTOGRAM)
    DrawType = DRAW_HISTOGRAM;

  SetIndexStyle (0, DRAW_LINE, STYLE_SOLID);
  SetIndexStyle (1, DrawType, STYLE_SOLID);
  SetIndexStyle (2, DrawType, STYLE_SOLID);
  SetIndexStyle (3, DrawType, STYLE_SOLID);
  SetIndexStyle (4, DrawType, STYLE_SOLID);
  SetIndexStyle (5, DRAW_ARROW);
  SetIndexArrow (5, 159);
  SetIndexBuffer (5, DnArr);
  SetIndexStyle (6, DRAW_ARROW);
  SetIndexArrow (6, 159);
  SetIndexBuffer (6, UpArr);

  SetIndexBuffer (0, CCI);
  SetIndexBuffer (1, UpBuffer1);
  SetIndexBuffer (2, UpBuffer2);
  SetIndexBuffer (3, DnBuffer1);
  SetIndexBuffer (4, DnBuffer2);
  SetIndexBuffer (5, DnArr);
  SetIndexBuffer (6, UpArr);

  IndicatorDigits (MarketInfo (Symbol (), MODE_DIGITS));

  string short_name;
  short_name =
    "CCI Filter(" + CCIPeriod + ", " + UpperTriggerLevel + ", " +
    LowerTriggerLevel + ", " + CriticalLevel + ")";
  IndicatorShortName (short_name);

  SetIndexLabel (0, "CCI");
  SetIndexLabel (1, "UpTrend");
  SetIndexLabel (2, "Mild UpTrend");
  SetIndexLabel (3, "Mild DownTrend");
  SetIndexLabel (4, "DownTrend");

  SetIndexDrawBegin (0, CCIPeriod);
  SetIndexDrawBegin (1, CCIPeriod);
  SetIndexDrawBegin (2, CCIPeriod);
  SetIndexDrawBegin (3, CCIPeriod);
  SetIndexDrawBegin (4, CCIPeriod);

  return (0);
}

//+------------------------------------------------------------------+
//| CCIFilter                                                        |
//+------------------------------------------------------------------+
int start () {
  int shift;
  double CCI0, CCI1;
  double UpDnZero, UpDnBuffer;

  if (UpperTriggerLevel < 0)
    UpperTriggerLevel = 0;

  if (LowerTriggerLevel > 0)
    UpperTriggerLevel = 0;

  for (shift = Bars - CCIPeriod - 1; shift >= 0; shift--) {
    DnArr[shift] = EMPTY_VALUE;
    UpArr[shift] = EMPTY_VALUE;
    CCI[shift] = EMPTY_VALUE;
    CCI0 = iCCI (NULL, 0, CCIPeriod, CCIPrice, shift);
    CCI1 = iCCI (NULL, 0, CCIPeriod, CCIPrice, shift + 1);
    UpDnZero = 0;
    UpDnBuffer = 1;
    if (!HISTOGRAM) {
      UpDnZero = EMPTY_VALUE;
      UpDnBuffer = CCI0;
      CCI[shift] = CCI0;
    }
    UpBuffer1[shift] = UpDnZero;
    UpBuffer2[shift] = UpDnZero;
    DnBuffer1[shift] = UpDnZero;
    DnBuffer2[shift] = UpDnZero;

    if (CCI0 > UpperTriggerLevel)
      UpBuffer1[shift] = UpDnBuffer;

    if (CCI0 > 0 && CCI0 <= UpperTriggerLevel)
      UpBuffer2[shift] = UpDnBuffer;

    if (CCI0 < 0 && CCI0 >= LowerTriggerLevel)
      DnBuffer1[shift] = UpDnBuffer;

    if (CCI0 < LowerTriggerLevel)
      DnBuffer2[shift] = UpDnBuffer;

    if (CCI0 > 0 && CCI1 <= 0) {
      if (!HISTOGRAM)
        UpArr[shift] = 0;
      if (shift == 0)
        Alerts (ZeroBuyAlert);
    }
    if (CCI0 < 0 && CCI1 >= 0) {
      if (!HISTOGRAM)
        DnArr[shift] = 0;
      if (shift == 0)
        Alerts (ZeroSellAlert);
    }
    if (CCI0 > UpperTriggerLevel && CCI1 <= UpperTriggerLevel
        && UpperTriggerLevel > 0) {
      if (!HISTOGRAM)
        UpArr[shift] = UpperTriggerLevel;
      if (shift == 0)
        Alerts (UpperTriggerBuyAlert);
    }
    if (CCI0 < UpperTriggerLevel && CCI1 >= UpperTriggerLevel
        && UpperTriggerLevel > 0) {
      if (!HISTOGRAM)
        DnArr[shift] = UpperTriggerLevel;
      if (shift == 0)
        Alerts (UpperTriggerSellAlert);
    }
    if (CCI0 > LowerTriggerLevel && CCI1 <= LowerTriggerLevel
        && LowerTriggerLevel < 0) {
      if (!HISTOGRAM)
        UpArr[shift] = LowerTriggerLevel;
      if (shift == 0)
        Alerts (LowerTriggerBuyAlert);
    }
    if (CCI0 < LowerTriggerLevel && CCI1 >= LowerTriggerLevel
        && LowerTriggerLevel < 0) {
      if (!HISTOGRAM)
        DnArr[shift] = LowerTriggerLevel;
      if (shift == 0)
        Alerts (LowerTriggerSellAlert);
    }
    if (MathAbs (CCI0) > CriticalLevel && MathAbs (CCI1) <= CriticalLevel) {
      if (shift == 0)
        Alerts (CriticalLevelAlert);
    }
    if (MathAbs (CCI0) < CriticalLevel && MathAbs (CCI1) >= CriticalLevel) {
      if (shift == 0)
        Alerts (CriticalLevelAlert);
    }
  }

  return (0);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Alerts (string AlertText) {
  static datetime timeprev;
  if (timeprev < iTime (NULL, 0, 0) && Alerts) {
    timeprev = iTime (NULL, 0, 0);
    Alert (AlertText, " ", Symbol (), " - ", Period (), "  at  ", Close[0], "  -  ", TimeToStr (CurTime (), TIME_SECONDS));
  }
}

//+------------------------------------------------------------------+
