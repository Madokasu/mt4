//+------------------------------------------------------------------+
//|                                    Madokasu_Spread_Monitor.mq4   |
//|                                                                  |
//|                                                                  |
//+------------------------------------------------------------------+
#property link      "https://madokasu-fx.blogspot.com"
#property indicator_separate_window
extern int Flag_If_Spread_Higher_Than = 20;
color Color1, Color2, Color3, Color4, Color5, Color6, Color7, Color8, Color9,
  Color10, Color11, Color12, Color13, Color14, Color15, Color16, Color17,
  Color18, Color19, Color20, Color21, Color22, Color23, Color24, Color25,
  Color26, Color27, Color28;
bool AlertOn = false;
bool firststart;
int SpreadPrev, Spread, Spreadhold;
int nDigits;
int
init () {
  IndicatorShortName ("Madokasu Spread Monitor");
  firststart = true;
  return (0);
}

int deinit () {
  return (0);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start () {

  if (firststart == false) {
    if (Spread != NormalizeDouble ((Ask - Bid) / Point, 0)) {
      SpreadPrev = Spread;
      if (AlertOn)
        Alert ("Spread Change on ", Symbol ()); //PlaySound("alert2.wav"); 
    }

    string Suffix = StringSubstr (Symbol (), 6, StringLen (Symbol ()) - 6);

    Spread = NormalizeDouble ((Ask - Bid) / Point, 0);
  }
  if (firststart == true) {
    SpreadPrev = NormalizeDouble ((Ask - Bid) / Point, 0);
    Spread = NormalizeDouble ((Ask - Bid) / Point, 0);
    firststart = false;
  }
  string alrt;
  if (AlertOn)
    alrt = "On";
  else
    alrt = "Off";

  int spreadEURUSD = MarketInfo ("EURUSD" + Suffix, MODE_SPREAD);
  int spreadCHFJPY = MarketInfo ("CHFJPY" + Suffix, MODE_SPREAD);
  int spreadUSDJPY = MarketInfo ("USDJPY" + Suffix, MODE_SPREAD);
  int spreadGBPUSD = MarketInfo ("GBPUSD" + Suffix, MODE_SPREAD);
  int spreadUSDCHF = MarketInfo ("USDCHF" + Suffix, MODE_SPREAD);
  int spreadUSDCAD = MarketInfo ("USDCAD" + Suffix, MODE_SPREAD);
  int spreadAUDUSD = MarketInfo ("AUDUSD" + Suffix, MODE_SPREAD);
  int spreadNZDUSD = MarketInfo ("NZDUSD" + Suffix, MODE_SPREAD);
  int spreadEURGBP = MarketInfo ("EURGBP" + Suffix, MODE_SPREAD);
  int spreadEURJPY = MarketInfo ("EURJPY" + Suffix, MODE_SPREAD);
  int spreadEURCHF = MarketInfo ("EURCHF" + Suffix, MODE_SPREAD);
  int spreadGBPJPY = MarketInfo ("GBPJPY" + Suffix, MODE_SPREAD);
  int spreadGBPCHF = MarketInfo ("GBPCHF" + Suffix, MODE_SPREAD);
  int spreadAUDJPY = MarketInfo ("AUDJPY" + Suffix, MODE_SPREAD);
  int spreadEURCAD = MarketInfo ("EURCAD" + Suffix, MODE_SPREAD);
  int spreadEURAUD = MarketInfo ("EURAUD" + Suffix, MODE_SPREAD);
  int spreadAUDCAD = MarketInfo ("AUDCAD" + Suffix, MODE_SPREAD);
  int spreadAUDNZD = MarketInfo ("AUDNZD" + Suffix, MODE_SPREAD);
  int spreadNZDJPY = MarketInfo ("NZDJPY" + Suffix, MODE_SPREAD);
  int spreadAUDCHF = MarketInfo ("AUDCHF" + Suffix, MODE_SPREAD);
  int spreadEURNZD = MarketInfo ("EURNZD" + Suffix, MODE_SPREAD);
  int spreadGBPNZD = MarketInfo ("GBPNZD" + Suffix, MODE_SPREAD);
  int spreadNZDCHF = MarketInfo ("NZDCHF" + Suffix, MODE_SPREAD);
  int spreadGBPCAD = MarketInfo ("GBPCAD" + Suffix, MODE_SPREAD);
  int spreadCADJPY = MarketInfo ("CADJPY" + Suffix, MODE_SPREAD);
  int spreadCADCHF = MarketInfo ("CADCHF" + Suffix, MODE_SPREAD);
  int spreadGBPAUD = MarketInfo ("GBPAUD" + Suffix, MODE_SPREAD);
  int spreadNZDCAD = MarketInfo ("NZDCAD" + Suffix, MODE_SPREAD);
  Color1 = Lime;
  Color2 = Lime;
  Color3 = Lime;
  Color4 = Lime;
  Color5 = Lime;
  Color6 = Lime;
  Color7 = Lime;
  Color8 = Lime;
  Color9 = Lime;
  Color10 = Lime;
  Color11 = Lime;
  Color12 = Lime;
  Color13 = Lime;
  Color14 = Lime;
  Color15 = Lime;
  Color16 = Lime;
  Color17 = Lime;
  Color18 = Lime;
  Color19 = Lime;
  Color20 = Lime;
  Color21 = Lime;
  Color22 = Lime;
  Color23 = Lime;
  Color24 = Lime;
  Color25 = Lime;
  Color26 = Lime;
  Color27 = Lime;
  Color28 = Lime;
  if (spreadEURUSD > Flag_If_Spread_Higher_Than) Color1 = Red;
  if (spreadCHFJPY > Flag_If_Spread_Higher_Than) Color2 = Red;
  if (spreadUSDJPY > Flag_If_Spread_Higher_Than) Color3 = Red;
  if (spreadGBPUSD > Flag_If_Spread_Higher_Than) Color4 = Red;
  if (spreadUSDCHF > Flag_If_Spread_Higher_Than) Color5 = Red;
  if (spreadUSDCAD > Flag_If_Spread_Higher_Than) Color6 = Red;
  if (spreadAUDUSD > Flag_If_Spread_Higher_Than) Color7 = Red;
  if (spreadNZDUSD > Flag_If_Spread_Higher_Than) Color8 = Red;
  if (spreadEURGBP > Flag_If_Spread_Higher_Than) Color9 = Red;
  if (spreadEURJPY > Flag_If_Spread_Higher_Than) Color10 = Red;
  if (spreadEURCHF > Flag_If_Spread_Higher_Than) Color11 = Red;
  if (spreadGBPJPY > Flag_If_Spread_Higher_Than) Color12 = Red;
  if (spreadGBPCHF > Flag_If_Spread_Higher_Than) Color13 = Red;
  if (spreadAUDJPY > Flag_If_Spread_Higher_Than) Color14 = Red;
  if (spreadEURCAD > Flag_If_Spread_Higher_Than) Color15 = Red;
  if (spreadEURAUD > Flag_If_Spread_Higher_Than) Color16 = Red;
  if (spreadAUDCAD > Flag_If_Spread_Higher_Than) Color17 = Red;
  if (spreadAUDNZD > Flag_If_Spread_Higher_Than) Color18 = Red;
  if (spreadNZDJPY > Flag_If_Spread_Higher_Than) Color19 = Red;
  if (spreadAUDCHF > Flag_If_Spread_Higher_Than) Color20 = Red;
  if (spreadEURNZD > Flag_If_Spread_Higher_Than) Color21 = Red;
  if (spreadGBPNZD > Flag_If_Spread_Higher_Than) Color22 = Red;
  if (spreadNZDCHF > Flag_If_Spread_Higher_Than) Color23 = Red;
  if (spreadGBPCAD > Flag_If_Spread_Higher_Than) Color24 = Red;
  if (spreadCADJPY > Flag_If_Spread_Higher_Than) Color25 = Red;
  if (spreadCADCHF > Flag_If_Spread_Higher_Than) Color26 = Red;
  if (spreadGBPAUD > Flag_If_Spread_Higher_Than) Color27 = Red;
  if (spreadNZDCAD > Flag_If_Spread_Higher_Than) Color28 = Red;

//-----------------------First Twelve------------------------------------------------------------------
  ObjectCreate ("Madokasu Spread Monitor1", OBJ_LABEL, WindowFind ("Madokasu Spread Monitor"), 0, 0);
  ObjectSetText ("Madokasu Spread Monitor1", "EURUSD:", 10, "Arial Bold", CadetBlue);
  ObjectSet ("Madokasu Spread Monitor1", OBJPROP_CORNER, 0);
  ObjectSet ("Madokasu Spread Monitor1", OBJPROP_XDISTANCE, 80);
  ObjectSet ("Madokasu Spread Monitor1", OBJPROP_YDISTANCE, 2);

  ObjectCreate ("Madokasu Spread Monitor2", OBJ_LABEL, WindowFind ("Madokasu Spread Monitor"), 0, 0);
  ObjectSetText ("Madokasu Spread Monitor2", DoubleToStr (spreadEURUSD, 0), 10, "Arial Bold", Color1);
  ObjectSet ("Madokasu Spread Monitor2", OBJPROP_CORNER, 0);
  ObjectSet ("Madokasu Spread Monitor2", OBJPROP_XDISTANCE, 140);
  ObjectSet ("Madokasu Spread Monitor2", OBJPROP_YDISTANCE, 2);

  ObjectCreate ("Madokasu Spread Monitor3", OBJ_LABEL, WindowFind ("Madokasu Spread Monitor"), 0, 0);
  ObjectSetText ("Madokasu Spread Monitor3", "CHFJPY:", 10, "Arial Bold", CadetBlue);
  ObjectSet ("Madokasu Spread Monitor3", OBJPROP_CORNER, 0);
  ObjectSet ("Madokasu Spread Monitor3", OBJPROP_XDISTANCE, 180);
  ObjectSet ("Madokasu Spread Monitor3", OBJPROP_YDISTANCE, 2);

  ObjectCreate ("Madokasu Spread Monitor4", OBJ_LABEL, WindowFind ("Madokasu Spread Monitor"), 0, 0);
  ObjectSetText ("Madokasu Spread Monitor4", DoubleToStr (spreadCHFJPY, 0), 10, "Arial Bold", Color2);
  ObjectSet ("Madokasu Spread Monitor4", OBJPROP_CORNER, 0);
  ObjectSet ("Madokasu Spread Monitor4", OBJPROP_XDISTANCE, 240);
  ObjectSet ("Madokasu Spread Monitor4", OBJPROP_YDISTANCE, 2);

  ObjectCreate ("Madokasu Spread Monitor5", OBJ_LABEL, WindowFind ("Madokasu Spread Monitor"), 0, 0);
  ObjectSetText ("Madokasu Spread Monitor5", "USDJPY:", 10, "Arial Bold", CadetBlue);
  ObjectSet ("Madokasu Spread Monitor5", OBJPROP_CORNER, 0);
  ObjectSet ("Madokasu Spread Monitor5", OBJPROP_XDISTANCE, 280);
  ObjectSet ("Madokasu Spread Monitor5", OBJPROP_YDISTANCE, 2);

  ObjectCreate ("Madokasu Spread Monitor6", OBJ_LABEL, WindowFind ("Madokasu Spread Monitor"), 0, 0);
  ObjectSetText ("Madokasu Spread Monitor6", DoubleToStr (spreadUSDJPY, 0), 10, "Arial Bold", Color3);
  ObjectSet ("Madokasu Spread Monitor6", OBJPROP_CORNER, 0);
  ObjectSet ("Madokasu Spread Monitor6", OBJPROP_XDISTANCE, 340);
  ObjectSet ("Madokasu Spread Monitor6", OBJPROP_YDISTANCE, 2);

  ObjectCreate ("Madokasu Spread Monitor7", OBJ_LABEL, WindowFind ("Madokasu Spread Monitor"), 0, 0);
  ObjectSetText ("Madokasu Spread Monitor7", "GBPUSD:", 10, "Arial Bold", CadetBlue);
  ObjectSet ("Madokasu Spread Monitor7", OBJPROP_CORNER, 0);
  ObjectSet ("Madokasu Spread Monitor7", OBJPROP_XDISTANCE, 380);
  ObjectSet ("Madokasu Spread Monitor7", OBJPROP_YDISTANCE, 2);

  ObjectCreate ("Madokasu Spread Monitor8", OBJ_LABEL, WindowFind ("Madokasu Spread Monitor"), 0, 0);
  ObjectSetText ("Madokasu Spread Monitor8", DoubleToStr (spreadGBPUSD, 0), 10, "Arial Bold", Color4);
  ObjectSet ("Madokasu Spread Monitor8", OBJPROP_CORNER, 0);
  ObjectSet ("Madokasu Spread Monitor8", OBJPROP_XDISTANCE, 440);
  ObjectSet ("Madokasu Spread Monitor8", OBJPROP_YDISTANCE, 2);

  ObjectCreate ("Madokasu Spread Monitor9", OBJ_LABEL, WindowFind ("Madokasu Spread Monitor"), 0, 0);
  ObjectSetText ("Madokasu Spread Monitor9", "USDCHF:", 10, "Arial Bold", CadetBlue);
  ObjectSet ("Madokasu Spread Monitor9", OBJPROP_CORNER, 0);
  ObjectSet ("Madokasu Spread Monitor9", OBJPROP_XDISTANCE, 480);
  ObjectSet ("Madokasu Spread Monitor9", OBJPROP_YDISTANCE, 2);

  ObjectCreate ("Madokasu Spread Monitor10", OBJ_LABEL, WindowFind ("Madokasu Spread Monitor"), 0, 0);
  ObjectSetText ("Madokasu Spread Monitor10", DoubleToStr (spreadUSDCHF, 0), 10, "Arial Bold", Color5);
  ObjectSet ("Madokasu Spread Monitor10", OBJPROP_CORNER, 0);
  ObjectSet ("Madokasu Spread Monitor10", OBJPROP_XDISTANCE, 540);
  ObjectSet ("Madokasu Spread Monitor10", OBJPROP_YDISTANCE, 2);

  ObjectCreate ("Madokasu Spread Monitor11", OBJ_LABEL, WindowFind ("Madokasu Spread Monitor"), 0, 0);
  ObjectSetText ("Madokasu Spread Monitor11", "USDCAD:", 10, "Arial Bold", CadetBlue);
  ObjectSet ("Madokasu Spread Monitor11", OBJPROP_CORNER, 0);
  ObjectSet ("Madokasu Spread Monitor11", OBJPROP_XDISTANCE, 580);
  ObjectSet ("Madokasu Spread Monitor11", OBJPROP_YDISTANCE, 2);

  ObjectCreate ("Madokasu Spread Monitor12", OBJ_LABEL, WindowFind ("Madokasu Spread Monitor"), 0, 0);
  ObjectSetText ("Madokasu Spread Monitor12", DoubleToStr (spreadUSDCAD, 0), 10, "Arial Bold", Color6);
  ObjectSet ("Madokasu Spread Monitor12", OBJPROP_CORNER, 0);
  ObjectSet ("Madokasu Spread Monitor12", OBJPROP_XDISTANCE, 640);
  ObjectSet ("Madokasu Spread Monitor12", OBJPROP_YDISTANCE, 2);


  ObjectCreate ("Madokasu Spread Monitor13", OBJ_LABEL, WindowFind ("Madokasu Spread Monitor"), 0, 0);
  ObjectSetText ("Madokasu Spread Monitor13", "AUDUSD:", 10, "Arial Bold", CadetBlue);
  ObjectSet ("Madokasu Spread Monitor13", OBJPROP_CORNER, 0);
  ObjectSet ("Madokasu Spread Monitor13", OBJPROP_XDISTANCE, 80);
  ObjectSet ("Madokasu Spread Monitor13", OBJPROP_YDISTANCE, 20);

  ObjectCreate ("Madokasu Spread Monitor14", OBJ_LABEL, WindowFind ("Madokasu Spread Monitor"), 0, 0);
  ObjectSetText ("Madokasu Spread Monitor14", DoubleToStr (spreadAUDUSD, 0), 10, "Arial Bold", Color7);
  ObjectSet ("Madokasu Spread Monitor14", OBJPROP_CORNER, 0);
  ObjectSet ("Madokasu Spread Monitor14", OBJPROP_XDISTANCE, 140);
  ObjectSet ("Madokasu Spread Monitor14", OBJPROP_YDISTANCE, 20);

  ObjectCreate ("Madokasu Spread Monitor15", OBJ_LABEL, WindowFind ("Madokasu Spread Monitor"), 0, 0);
  ObjectSetText ("Madokasu Spread Monitor15", "NZDUSD:", 10, "Arial Bold", CadetBlue);
  ObjectSet ("Madokasu Spread Monitor15", OBJPROP_CORNER, 0);
  ObjectSet ("Madokasu Spread Monitor15", OBJPROP_XDISTANCE, 180);
  ObjectSet ("Madokasu Spread Monitor15", OBJPROP_YDISTANCE, 20);

  ObjectCreate ("Madokasu Spread Monitor16", OBJ_LABEL, WindowFind ("Madokasu Spread Monitor"), 0, 0);
  ObjectSetText ("Madokasu Spread Monitor16", DoubleToStr (spreadNZDUSD, 0), 10, "Arial Bold", Color8);
  ObjectSet ("Madokasu Spread Monitor16", OBJPROP_CORNER, 0);
  ObjectSet ("Madokasu Spread Monitor16", OBJPROP_XDISTANCE, 240);
  ObjectSet ("Madokasu Spread Monitor16", OBJPROP_YDISTANCE, 20);

  ObjectCreate ("Madokasu Spread Monitor17", OBJ_LABEL, WindowFind ("Madokasu Spread Monitor"), 0, 0);
  ObjectSetText ("Madokasu Spread Monitor17", "EURGBP:", 10, "Arial Bold", CadetBlue);
  ObjectSet ("Madokasu Spread Monitor17", OBJPROP_CORNER, 0);
  ObjectSet ("Madokasu Spread Monitor17", OBJPROP_XDISTANCE, 280);
  ObjectSet ("Madokasu Spread Monitor17", OBJPROP_YDISTANCE, 20);

  ObjectCreate ("Madokasu Spread Monitor18", OBJ_LABEL, WindowFind ("Madokasu Spread Monitor"), 0, 0);
  ObjectSetText ("Madokasu Spread Monitor18", DoubleToStr (spreadEURGBP, 0), 10, "Arial Bold", Color9);
  ObjectSet ("Madokasu Spread Monitor18", OBJPROP_CORNER, 0);
  ObjectSet ("Madokasu Spread Monitor18", OBJPROP_XDISTANCE, 340);
  ObjectSet ("Madokasu Spread Monitor18", OBJPROP_YDISTANCE, 20);

  ObjectCreate ("Madokasu Spread Monitor19", OBJ_LABEL, WindowFind ("Madokasu Spread Monitor"), 0, 0);
  ObjectSetText ("Madokasu Spread Monitor19", "EURJPY:", 10, "Arial Bold", CadetBlue);
  ObjectSet ("Madokasu Spread Monitor19", OBJPROP_CORNER, 0);
  ObjectSet ("Madokasu Spread Monitor19", OBJPROP_XDISTANCE, 380);
  ObjectSet ("Madokasu Spread Monitor19", OBJPROP_YDISTANCE, 20);

  ObjectCreate ("Madokasu Spread Monitor20", OBJ_LABEL, WindowFind ("Madokasu Spread Monitor"), 0, 0);
  ObjectSetText ("Madokasu Spread Monitor20", DoubleToStr (spreadEURJPY, 0), 10, "Arial Bold", Color10);
  ObjectSet ("Madokasu Spread Monitor20", OBJPROP_CORNER, 0);
  ObjectSet ("Madokasu Spread Monitor20", OBJPROP_XDISTANCE, 440);
  ObjectSet ("Madokasu Spread Monitor20", OBJPROP_YDISTANCE, 20);

  ObjectCreate ("Madokasu Spread Monitor21", OBJ_LABEL, WindowFind ("Madokasu Spread Monitor"), 0, 0);
  ObjectSetText ("Madokasu Spread Monitor21", "EURCHF:", 10, "Arial Bold", CadetBlue);
  ObjectSet ("Madokasu Spread Monitor21", OBJPROP_CORNER, 0);
  ObjectSet ("Madokasu Spread Monitor21", OBJPROP_XDISTANCE, 480);
  ObjectSet ("Madokasu Spread Monitor21", OBJPROP_YDISTANCE, 20);

  ObjectCreate ("Madokasu Spread Monitor22", OBJ_LABEL, WindowFind ("Madokasu Spread Monitor"), 0, 0);
  ObjectSetText ("Madokasu Spread Monitor22", DoubleToStr (spreadEURCHF, 0), 10, "Arial Bold", Color11);
  ObjectSet ("Madokasu Spread Monitor22", OBJPROP_CORNER, 0);
  ObjectSet ("Madokasu Spread Monitor22", OBJPROP_XDISTANCE, 540);
  ObjectSet ("Madokasu Spread Monitor22", OBJPROP_YDISTANCE, 20);

  ObjectCreate ("Madokasu Spread Monitor23", OBJ_LABEL, WindowFind ("Madokasu Spread Monitor"), 0, 0);
  ObjectSetText ("Madokasu Spread Monitor23", "GBPJPY:", 10, "Arial Bold", CadetBlue);
  ObjectSet ("Madokasu Spread Monitor23", OBJPROP_CORNER, 0);
  ObjectSet ("Madokasu Spread Monitor23", OBJPROP_XDISTANCE, 580);
  ObjectSet ("Madokasu Spread Monitor23", OBJPROP_YDISTANCE, 20);

  ObjectCreate ("Madokasu Spread Monitor24", OBJ_LABEL, WindowFind ("Madokasu Spread Monitor"), 0, 0);
  ObjectSetText ("Madokasu Spread Monitor24", DoubleToStr (spreadGBPJPY, 0), 10, "Arial Bold", Color12);
  ObjectSet ("Madokasu Spread Monitor24", OBJPROP_CORNER, 0);
  ObjectSet ("Madokasu Spread Monitor24", OBJPROP_XDISTANCE, 640);
  ObjectSet ("Madokasu Spread Monitor24", OBJPROP_YDISTANCE, 20);
//-------------------------------------------------------------------------------------------------
//-------------------------Second twelve-----------------------------------------------------------
  ObjectCreate ("Madokasu Spread Monitor25", OBJ_LABEL, WindowFind ("Madokasu Spread Monitor"), 0, 0);
  ObjectSetText ("Madokasu Spread Monitor25", "GBPCHF:", 10, "Arial Bold", CadetBlue);
  ObjectSet ("Madokasu Spread Monitor25", OBJPROP_CORNER, 0);
  ObjectSet ("Madokasu Spread Monitor25", OBJPROP_XDISTANCE, 80);
  ObjectSet ("Madokasu Spread Monitor25", OBJPROP_YDISTANCE, 38);

  ObjectCreate ("Madokasu Spread Monitor26", OBJ_LABEL, WindowFind ("Madokasu Spread Monitor"), 0, 0);
  ObjectSetText ("Madokasu Spread Monitor26", DoubleToStr (spreadGBPCHF, 0), 10, "Arial Bold", Color13);
  ObjectSet ("Madokasu Spread Monitor26", OBJPROP_CORNER, 0);
  ObjectSet ("Madokasu Spread Monitor26", OBJPROP_XDISTANCE, 140);
  ObjectSet ("Madokasu Spread Monitor26", OBJPROP_YDISTANCE, 38);

  ObjectCreate ("Madokasu Spread Monitor27", OBJ_LABEL, WindowFind ("Madokasu Spread Monitor"), 0, 0);
  ObjectSetText ("Madokasu Spread Monitor27", "AUDJPY:", 10, "Arial Bold", CadetBlue);
  ObjectSet ("Madokasu Spread Monitor27", OBJPROP_CORNER, 0);
  ObjectSet ("Madokasu Spread Monitor27", OBJPROP_XDISTANCE, 180);
  ObjectSet ("Madokasu Spread Monitor27", OBJPROP_YDISTANCE, 38);

  ObjectCreate ("Madokasu Spread Monitor28", OBJ_LABEL, WindowFind ("Madokasu Spread Monitor"), 0, 0);
  ObjectSetText ("Madokasu Spread Monitor28", DoubleToStr (spreadAUDJPY, 0), 10, "Arial Bold", Color14);
  ObjectSet ("Madokasu Spread Monitor28", OBJPROP_CORNER, 0);
  ObjectSet ("Madokasu Spread Monitor28", OBJPROP_XDISTANCE, 240);
  ObjectSet ("Madokasu Spread Monitor28", OBJPROP_YDISTANCE, 38);

  ObjectCreate ("Madokasu Spread Monitor29", OBJ_LABEL, WindowFind ("Madokasu Spread Monitor"), 0, 0);
  ObjectSetText ("Madokasu Spread Monitor29", "EURCAD:", 10, "Arial Bold", CadetBlue);
  ObjectSet ("Madokasu Spread Monitor29", OBJPROP_CORNER, 0);
  ObjectSet ("Madokasu Spread Monitor29", OBJPROP_XDISTANCE, 280);
  ObjectSet ("Madokasu Spread Monitor29", OBJPROP_YDISTANCE, 38);

  ObjectCreate ("Madokasu Spread Monitor30", OBJ_LABEL, WindowFind ("Madokasu Spread Monitor"), 0, 0);
  ObjectSetText ("Madokasu Spread Monitor30", DoubleToStr (spreadEURCAD, 0), 10, "Arial Bold", Color15);
  ObjectSet ("Madokasu Spread Monitor30", OBJPROP_CORNER, 0);
  ObjectSet ("Madokasu Spread Monitor30", OBJPROP_XDISTANCE, 340);
  ObjectSet ("Madokasu Spread Monitor30", OBJPROP_YDISTANCE, 38);

  ObjectCreate ("Madokasu Spread Monitor31", OBJ_LABEL, WindowFind ("Madokasu Spread Monitor"), 0, 0);
  ObjectSetText ("Madokasu Spread Monitor31", "EURAUD:", 10, "Arial Bold", CadetBlue);
  ObjectSet ("Madokasu Spread Monitor31", OBJPROP_CORNER, 0);
  ObjectSet ("Madokasu Spread Monitor31", OBJPROP_XDISTANCE, 380);
  ObjectSet ("Madokasu Spread Monitor31", OBJPROP_YDISTANCE, 38);

  ObjectCreate ("Madokasu Spread Monitor32", OBJ_LABEL, WindowFind ("Madokasu Spread Monitor"), 0, 0);
  ObjectSetText ("Madokasu Spread Monitor32", DoubleToStr (spreadEURAUD, 0), 10, "Arial Bold", Color16);
  ObjectSet ("Madokasu Spread Monitor32", OBJPROP_CORNER, 0);
  ObjectSet ("Madokasu Spread Monitor32", OBJPROP_XDISTANCE, 440);
  ObjectSet ("Madokasu Spread Monitor32", OBJPROP_YDISTANCE, 38);

  ObjectCreate ("Madokasu Spread Monitor33", OBJ_LABEL, WindowFind ("Madokasu Spread Monitor"), 0, 0);
  ObjectSetText ("Madokasu Spread Monitor33", "AUDCAD:", 10, "Arial Bold", CadetBlue);
  ObjectSet ("Madokasu Spread Monitor33", OBJPROP_CORNER, 0);
  ObjectSet ("Madokasu Spread Monitor33", OBJPROP_XDISTANCE, 480);
  ObjectSet ("Madokasu Spread Monitor33", OBJPROP_YDISTANCE, 38);

  ObjectCreate ("Madokasu Spread Monitor34", OBJ_LABEL, WindowFind ("Madokasu Spread Monitor"), 0, 0);
  ObjectSetText ("Madokasu Spread Monitor34", DoubleToStr (spreadAUDCAD, 0), 10, "Arial Bold", Color17);
  ObjectSet ("Madokasu Spread Monitor34", OBJPROP_CORNER, 0);
  ObjectSet ("Madokasu Spread Monitor34", OBJPROP_XDISTANCE, 540);
  ObjectSet ("Madokasu Spread Monitor34", OBJPROP_YDISTANCE, 38);

  ObjectCreate ("Madokasu Spread Monitor35", OBJ_LABEL, WindowFind ("Madokasu Spread Monitor"), 0, 0);
  ObjectSetText ("Madokasu Spread Monitor35", "AUDNZD:", 10, "Arial Bold", CadetBlue);
  ObjectSet ("Madokasu Spread Monitor35", OBJPROP_CORNER, 0);
  ObjectSet ("Madokasu Spread Monitor35", OBJPROP_XDISTANCE, 580);
  ObjectSet ("Madokasu Spread Monitor35", OBJPROP_YDISTANCE, 38);

  ObjectCreate ("Madokasu Spread Monitor36", OBJ_LABEL, WindowFind ("Madokasu Spread Monitor"), 0, 0);
  ObjectSetText ("Madokasu Spread Monitor36", DoubleToStr (spreadAUDNZD, 0), 10, "Arial Bold", Color18);
  ObjectSet ("Madokasu Spread Monitor36", OBJPROP_CORNER, 0);
  ObjectSet ("Madokasu Spread Monitor36", OBJPROP_XDISTANCE, 640);
  ObjectSet ("Madokasu Spread Monitor36", OBJPROP_YDISTANCE, 38);


  ObjectCreate ("Madokasu Spread Monitor37", OBJ_LABEL, WindowFind ("Madokasu Spread Monitor"), 0, 0);
  ObjectSetText ("Madokasu Spread Monitor37", "NZDJPY:", 10, "Arial Bold", CadetBlue);
  ObjectSet ("Madokasu Spread Monitor37", OBJPROP_CORNER, 0);
  ObjectSet ("Madokasu Spread Monitor37", OBJPROP_XDISTANCE, 80);
  ObjectSet ("Madokasu Spread Monitor37", OBJPROP_YDISTANCE, 56);

  ObjectCreate ("Madokasu Spread Monitor38", OBJ_LABEL, WindowFind ("Madokasu Spread Monitor"), 0, 0);
  ObjectSetText ("Madokasu Spread Monitor38", DoubleToStr (spreadNZDJPY, 0), 10, "Arial Bold", Color19);
  ObjectSet ("Madokasu Spread Monitor38", OBJPROP_CORNER, 0);
  ObjectSet ("Madokasu Spread Monitor38", OBJPROP_XDISTANCE, 140);
  ObjectSet ("Madokasu Spread Monitor38", OBJPROP_YDISTANCE, 56);

  ObjectCreate ("Madokasu Spread Monitor39", OBJ_LABEL, WindowFind ("Madokasu Spread Monitor"), 0, 0);
  ObjectSetText ("Madokasu Spread Monitor39", "AUDCHF:", 10, "Arial Bold", CadetBlue);
  ObjectSet ("Madokasu Spread Monitor39", OBJPROP_CORNER, 0);
  ObjectSet ("Madokasu Spread Monitor39", OBJPROP_XDISTANCE, 180);
  ObjectSet ("Madokasu Spread Monitor39", OBJPROP_YDISTANCE, 56);

  ObjectCreate ("Madokasu Spread Monitor40", OBJ_LABEL, WindowFind ("Madokasu Spread Monitor"), 0, 0);
  ObjectSetText ("Madokasu Spread Monitor40", DoubleToStr (spreadAUDCHF, 0), 10, "Arial Bold", Color20);
  ObjectSet ("Madokasu Spread Monitor40", OBJPROP_CORNER, 0);
  ObjectSet ("Madokasu Spread Monitor40", OBJPROP_XDISTANCE, 240);
  ObjectSet ("Madokasu Spread Monitor40", OBJPROP_YDISTANCE, 56);

  ObjectCreate ("Madokasu Spread Monitor41", OBJ_LABEL, WindowFind ("Madokasu Spread Monitor"), 0, 0);
  ObjectSetText ("Madokasu Spread Monitor41", "EURNZD:", 10, "Arial Bold", CadetBlue);
  ObjectSet ("Madokasu Spread Monitor41", OBJPROP_CORNER, 0);
  ObjectSet ("Madokasu Spread Monitor41", OBJPROP_XDISTANCE, 280);
  ObjectSet ("Madokasu Spread Monitor41", OBJPROP_YDISTANCE, 56);

  ObjectCreate ("Madokasu Spread Monitor42", OBJ_LABEL, WindowFind ("Madokasu Spread Monitor"), 0, 0);
  ObjectSetText ("Madokasu Spread Monitor42", DoubleToStr (spreadEURNZD, 0), 10, "Arial Bold", Color21);
  ObjectSet ("Madokasu Spread Monitor42", OBJPROP_CORNER, 0);
  ObjectSet ("Madokasu Spread Monitor42", OBJPROP_XDISTANCE, 340);
  ObjectSet ("Madokasu Spread Monitor42", OBJPROP_YDISTANCE, 56);

  ObjectCreate ("Madokasu Spread Monitor43", OBJ_LABEL, WindowFind ("Madokasu Spread Monitor"), 0, 0);
  ObjectSetText ("Madokasu Spread Monitor43", "GBPNZD:", 10, "Arial Bold", CadetBlue);
  ObjectSet ("Madokasu Spread Monitor43", OBJPROP_CORNER, 0);
  ObjectSet ("Madokasu Spread Monitor43", OBJPROP_XDISTANCE, 380);
  ObjectSet ("Madokasu Spread Monitor43", OBJPROP_YDISTANCE, 56);

  ObjectCreate ("Madokasu Spread Monitor44", OBJ_LABEL, WindowFind ("Madokasu Spread Monitor"), 0, 0);
  ObjectSetText ("Madokasu Spread Monitor44", DoubleToStr (spreadGBPNZD, 0), 10, "Arial Bold", Color22);
  ObjectSet ("Madokasu Spread Monitor44", OBJPROP_CORNER, 0);
  ObjectSet ("Madokasu Spread Monitor44", OBJPROP_XDISTANCE, 440);
  ObjectSet ("Madokasu Spread Monitor44", OBJPROP_YDISTANCE, 56);

  ObjectCreate ("Madokasu Spread Monitor45", OBJ_LABEL, WindowFind ("Madokasu Spread Monitor"), 0, 0);
  ObjectSetText ("Madokasu Spread Monitor45", "NZDCHF:", 10, "Arial Bold", CadetBlue);
  ObjectSet ("Madokasu Spread Monitor45", OBJPROP_CORNER, 0);
  ObjectSet ("Madokasu Spread Monitor45", OBJPROP_XDISTANCE, 480);
  ObjectSet ("Madokasu Spread Monitor45", OBJPROP_YDISTANCE, 56);

  ObjectCreate ("Madokasu Spread Monitor46", OBJ_LABEL, WindowFind ("Madokasu Spread Monitor"), 0, 0);
  ObjectSetText ("Madokasu Spread Monitor46", DoubleToStr (spreadNZDCHF, 0), 10, "Arial Bold", Color23);
  ObjectSet ("Madokasu Spread Monitor46", OBJPROP_CORNER, 0);
  ObjectSet ("Madokasu Spread Monitor46", OBJPROP_XDISTANCE, 540);
  ObjectSet ("Madokasu Spread Monitor46", OBJPROP_YDISTANCE, 56);

  ObjectCreate ("Madokasu Spread Monitor47", OBJ_LABEL, WindowFind ("Madokasu Spread Monitor"), 0, 0);
  ObjectSetText ("Madokasu Spread Monitor47", "GBPCAD:", 10, "Arial Bold", CadetBlue);
  ObjectSet ("Madokasu Spread Monitor47", OBJPROP_CORNER, 0);
  ObjectSet ("Madokasu Spread Monitor47", OBJPROP_XDISTANCE, 580);
  ObjectSet ("Madokasu Spread Monitor47", OBJPROP_YDISTANCE, 56);

  ObjectCreate ("Madokasu Spread Monitor48", OBJ_LABEL, WindowFind ("Madokasu Spread Monitor"), 0, 0);
  ObjectSetText ("Madokasu Spread Monitor48", DoubleToStr (spreadGBPCAD, 0), 10, "Arial Bold", Color24);
  ObjectSet ("Madokasu Spread Monitor48", OBJPROP_CORNER, 0);
  ObjectSet ("Madokasu Spread Monitor48", OBJPROP_XDISTANCE, 640);
  ObjectSet ("Madokasu Spread Monitor48", OBJPROP_YDISTANCE, 56);
//-------------------------------------------------------------------------------------------------
  ObjectCreate ("Madokasu Spread Monitor49", OBJ_LABEL, WindowFind ("Madokasu Spread Monitor"), 0, 0);
  ObjectSetText ("Madokasu Spread Monitor49", "CADJPY:", 10, "Arial Bold", CadetBlue);
  ObjectSet ("Madokasu Spread Monitor49", OBJPROP_CORNER, 0);
  ObjectSet ("Madokasu Spread Monitor49", OBJPROP_XDISTANCE, 80);
  ObjectSet ("Madokasu Spread Monitor49", OBJPROP_YDISTANCE, 74);

  ObjectCreate ("Madokasu Spread Monitor50", OBJ_LABEL, WindowFind ("Madokasu Spread Monitor"), 0, 0);
  ObjectSetText ("Madokasu Spread Monitor50", DoubleToStr (spreadCADJPY, 0), 10, "Arial Bold", Color25);
  ObjectSet ("Madokasu Spread Monitor50", OBJPROP_CORNER, 0);
  ObjectSet ("Madokasu Spread Monitor50", OBJPROP_XDISTANCE, 140);
  ObjectSet ("Madokasu Spread Monitor50", OBJPROP_YDISTANCE, 74);

  ObjectCreate ("Madokasu Spread Monitor51", OBJ_LABEL, WindowFind ("Madokasu Spread Monitor"), 0, 0);
  ObjectSetText ("Madokasu Spread Monitor51", "CADCHF:", 10, "Arial Bold", CadetBlue);
  ObjectSet ("Madokasu Spread Monitor51", OBJPROP_CORNER, 0);
  ObjectSet ("Madokasu Spread Monitor51", OBJPROP_XDISTANCE, 180);
  ObjectSet ("Madokasu Spread Monitor51", OBJPROP_YDISTANCE, 74);

  ObjectCreate ("Madokasu Spread Monitor52", OBJ_LABEL, WindowFind ("Madokasu Spread Monitor"), 0, 0);
  ObjectSetText ("Madokasu Spread Monitor52", DoubleToStr (spreadCADCHF, 0), 10, "Arial Bold", Color26);
  ObjectSet ("Madokasu Spread Monitor52", OBJPROP_CORNER, 0);
  ObjectSet ("Madokasu Spread Monitor52", OBJPROP_XDISTANCE, 240);
  ObjectSet ("Madokasu Spread Monitor52", OBJPROP_YDISTANCE, 74);

  ObjectCreate ("Madokasu Spread Monitor53", OBJ_LABEL, WindowFind ("Madokasu Spread Monitor"), 0, 0);
  ObjectSetText ("Madokasu Spread Monitor53", "GBPAUD:", 10, "Arial Bold", CadetBlue);
  ObjectSet ("Madokasu Spread Monitor53", OBJPROP_CORNER, 0);
  ObjectSet ("Madokasu Spread Monitor53", OBJPROP_XDISTANCE, 280);
  ObjectSet ("Madokasu Spread Monitor53", OBJPROP_YDISTANCE, 74);

  ObjectCreate ("Madokasu Spread Monitor54", OBJ_LABEL, WindowFind ("Madokasu Spread Monitor"), 0, 0);
  ObjectSetText ("Madokasu Spread Monitor54", DoubleToStr (spreadGBPAUD, 0), 10, "Arial Bold", Color27);
  ObjectSet ("Madokasu Spread Monitor54", OBJPROP_CORNER, 0);
  ObjectSet ("Madokasu Spread Monitor54", OBJPROP_XDISTANCE, 340);
  ObjectSet ("Madokasu Spread Monitor54", OBJPROP_YDISTANCE, 74);

  ObjectCreate ("Madokasu Spread Monitor55", OBJ_LABEL, WindowFind ("Madokasu Spread Monitor"), 0, 0);
  ObjectSetText ("Madokasu Spread Monitor55", "NZDCAD:", 10, "Arial Bold", CadetBlue);
  ObjectSet ("Madokasu Spread Monitor55", OBJPROP_CORNER, 0);
  ObjectSet ("Madokasu Spread Monitor55", OBJPROP_XDISTANCE, 380);
  ObjectSet ("Madokasu Spread Monitor55", OBJPROP_YDISTANCE, 74);

  ObjectCreate ("Madokasu Spread Monitor56", OBJ_LABEL, WindowFind ("Madokasu Spread Monitor"), 0, 0);
  ObjectSetText ("Madokasu Spread Monitor56", DoubleToStr (spreadNZDCAD, 0), 10, "Arial Bold", Color28);
  ObjectSet ("Madokasu Spread Monitor56", OBJPROP_CORNER, 0);
  ObjectSet ("Madokasu Spread Monitor56", OBJPROP_XDISTANCE, 440);
  ObjectSet ("Madokasu Spread Monitor56", OBJPROP_YDISTANCE, 74);

  return (0);
}

//+------------------------------------------------------------------+
