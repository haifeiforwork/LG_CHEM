package hris.E.E21Expense;

/**
 * E21ExpenseChkData.java
 * 자녀별 장학자금 수혜횟수를 담는 데이타
 *
 * @author 김성일
 * @version 1.0, 2002/01/05
 */
public class E21ExpenseChkData extends com.sns.jdf.EntityData {
    public String subty;
    public String objps;
    public String grade;
    public String subf_type;
    public String count;
    public String enter;

    public String getsubty() {
        return subty;
    }

    public void setsubty(String subty) {
        this.subty = subty;
    }

    public String getobjps() {
        return objps;
    }

    public void setobjps(String objps) {
        this.objps = objps;
    }

    public String getgrade() {
        return grade;
    }

    public void setgrade(String grade) {
        this.grade = grade;
    }

    public String getsubf_type() {
        return subf_type;
    }

    public void setsubf_type(String subf_type) {
        this.subf_type = subf_type;
    }

    public String getcount() {
        return count;
    }

    public void setcount(String count) {
        this.count = count;
    }

    public String getenter() {
        return enter;
    }

    public void setenter(String enter) {
        this.enter = enter;
    }




}