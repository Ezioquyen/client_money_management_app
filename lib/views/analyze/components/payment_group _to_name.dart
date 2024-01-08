class PaymentGroupToName{
  static String convert(int id){
    if(id == 0) return "Khác";
    if(id==1) return "Nhà";
    return "";
  }
}