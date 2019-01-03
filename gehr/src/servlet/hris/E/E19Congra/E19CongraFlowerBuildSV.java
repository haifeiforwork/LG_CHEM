/********************************************************************************/
/*                                                                              */
/*   System Name  : ESS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 경조금                                                      */
/*   Program Name : 경조금 신청                                                 */
/*   Program ID   : E19CongraFlowerBuildSV                                            */
/*   Description  :  화환신청할 수 있도록 하는 Class                        */
/*   Note         : 없음                                                        */
/*   Creation     : 2017-07-19 eunha                                          */
/*   Update       : 2005-02-14  이승희
/********************************************************************************/

package servlet.hris.E.E19Congra;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.sns.jdf.GeneralException;

public class E19CongraFlowerBuildSV extends E19CongraBuildSV
{


	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
		process(req, res, "Y");
	}


}
