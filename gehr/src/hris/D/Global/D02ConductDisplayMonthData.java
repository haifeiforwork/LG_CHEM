/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 근태                                                        */
/*   Program Name : 근태실적정보                                                */
/*   Program ID   : D02ConductDisplayMonthData                                       */
/*   Description  : Time & Attendance month data                     */
/*   Note         :                                                             */
/*   Creation     : 2007-09-12  zhouguangwen   global e-hr update                                         */
/*   Update       :                                                            */
/*                                                                            */
/********************************************************************************/

package hris.D.Global;

/**
 * D02ConductDisplayMonthData.java
 *  get monthly total
 *   [관련 RFC] : ZHRW_RFC_GET_TIMEDATA
 *
 * @author zhouguangwen
 * @version 1.0
 * 2007/09/12
 */

public class D02ConductDisplayMonthData extends com.sns.jdf.EntityData{



	   public String DATE;      		// Field of type DATS
	   public String DWS;       		// Daily Work Schedule
	   public String OT_WOR;    	// Attendance and Absence Days
	   public String OT_OFF;    	// Attendance and Absence Days
	   public String OT_HOL;    	// Attendance and Absence Days
	   public String DU_FIX;    	// Attendance and Absence Days
	   public String DU_WOR;    	// Attendance and Absence Days
	   public String DU_OFF;    	// Attendance and Absence Days
	   public String DU_HOL;    	// Attendance and Absence Days
	   public String LE_ANN;    	// Attendance and Absence Days
	   public String LE_SIC;   		// Attendance and Absence Days
	   public String LE_PER;    	// Attendance and Absence Days
	   public String LE_OTH;    	// Attendance and Absence Days
	   public String AB_ABS;    	// Byte Value
	   public String AB_TAR;    	// Byte Value
	   public String AB_EAR;    	// Byte Value
	   public String OT_ADD;      	// 50%
	   public String LE_DMD;     	// On demand

	   // Case of USA
	   public String OT_HRS;      	// OverTime Hours




}
