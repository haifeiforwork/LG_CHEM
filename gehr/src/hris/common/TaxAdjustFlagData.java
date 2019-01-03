package	hris.common;

/**
 * TaxAdjustFlagData.java
 *  로그인시에 연말정산기간인지 유무등을 가져온 데이터
 * 
 * @author 김성일  
 * @version 1.0, 2001/02/04
 */
public class TaxAdjustFlagData extends com.sns.jdf.EntityData {

     public boolean canPeriod = false;   // 메뉴에서 연말정산을 할수 있는 기간인지 유무
     public boolean canDetail = false;   // 연말정산 내역조회를 할수 있는 기간인지 유무
     public boolean canBuild  = false;   // 연말정산 신청을 할수 있는 기간인지 유무
     public boolean canSimul  = false;   // 연말정산 시뮬레이션을 할수 있는 기간인지 유무
     public String  targetYear;   // 연말정산 회계년도(?)
}
