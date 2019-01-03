/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 근태                                                        */
/*   Program Name : 근태실적정보                                                */
/*   Program ID   : D02ConductDisplayDayData                                       */
/*   Description  : Time & Attendance day data                     */
/*   Note         :                                                             */
/*   Creation     : 2007-09-12  zhouguangwen   global e-hr update                                         */
/*   Update       : 2007-11-08  zhouguangwen   RFC changed                                                         */
/*                                                                            */
/********************************************************************************/


package hris.D.Global;

/**
 * D02ConductDisplayMonthData.java
 *  get day detail
 *   [관련 RFC] : ZHRW_RFC_GET_TIMEDATA
 *
 * @author zhouguangwen
 * @version 2.0
 * 2007/11/08
 */
public class D02ConductDisplayDayData extends com.sns.jdf.EntityData{

	   public String   DATE ;        //Field of type DATS
	   public String   DWS ;         //Daily Work Schedule
	   public String   OT_WOR ;      //Attendance and Absence Days
	   public String   OT_OFF ;      //Attendance and Absence Days
	   public String   OT_HOL ;      //Attendance and Absence Days
	   public String   DU_FIX ;      //Attendance and Absence Days
	   public String   DU_WOR ;      //Attendance and Absence Days
	   public String   DU_OFF ;      //Attendance and Absence Days
	   public String   DU_HOL ;      //Attendance and Absence Days
	   public String   LE_ANN ;      //Attendance and Absence Days
	   public String   LE_SIC ;      //Attendance and Absence Days
	   public String   LE_PER ;      //Attendance and Absence Days
	   public String   LE_OTH ;      //Attendance and Absence Days
	   public String   AB_ABS ;      //Byte Value
	   public String   AB_TAR ;      //Byte Value
	   public String   AB_EAR ;      //Byte Value
	   public String OT_ADD;      	// 50%
	   public String LE_DMD;      	// On demand

	   // Case of USA
	   public String OT_HRS;      	// OverTime Hours

}
