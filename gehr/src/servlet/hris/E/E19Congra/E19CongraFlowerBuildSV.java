/********************************************************************************/
/*                                                                              */
/*   System Name  : ESS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : ������                                                      */
/*   Program Name : ������ ��û                                                 */
/*   Program ID   : E19CongraFlowerBuildSV                                            */
/*   Description  :  ȭȯ��û�� �� �ֵ��� �ϴ� Class                        */
/*   Note         : ����                                                        */
/*   Creation     : 2017-07-19 eunha                                          */
/*   Update       : 2005-02-14  �̽���
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
