package hris.N;

import com.sns.jdf.Logger;

import java.text.*;
import java.util.*;

public  class  EHRBIOCheck  {
	public String birth;
	public int body;
	public int feel;
	public int intel;
	public int bState;
	public int fState;
	public int iState;
	public EHRBIOCheck() {

	}

	public void calBio(long days){
		this.body = calBody(days);
		this.feel = calFeel(days);
		this.intel = calIntel(days);

		if(this.body > calBody(days-1)) this.bState = 1; // »ó½Â
		else this.bState = -1; // ÇÏ°­

		if(this.feel > calFeel(days-1)) this.fState = 1; // »ó½Â
		else this.fState = -1; // ÇÏ°­

		if(this.intel > calIntel(days-1)) this.iState = 1; // »ó½Â
		else this.iState = -1; // ÇÏ°­
	}

	public int calBody(long days){
		return (int)(Math.sin(2.0 * Math.PI * ((double)days/23.0)) * 100 + 0.5);
	}

	public int calFeel(long days){
		return (int)(Math.sin(2.0 * Math.PI * ((double)days/28.0)) * 100 + 0.5);
	}

	public int calIntel(long days){
		return (int)(Math.sin(2.0 * Math.PI * ((double)days/33.0)) * 100 + 0.5);
	}


	public void setBirth(String birth) throws ParseException {
		long days;
		this.birth = birth;


		Calendar cNow = Calendar.getInstance();
		DateFormat form = DateFormat.getDateInstance(DateFormat.MEDIUM,Locale.KOREAN);
		Date dNow,dBirth;


		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
		Date date = formatter.parse(birth);
		dNow = cNow.getTime();
		days = (long)(dNow.getTime() - date.getTime())/(1000*60*60*24) -1;
		calBio(days);
	}

	public int getBody() {
		return (this.body);
	}

	public int getFeel() {
		return (this.feel);
	}

	public int getIntel() {
		return (this.intel);
	}

	public int getBState() {
		return (this.bState);
	}

	public int getFState() {
		return (this.fState);
	}

	public int getIState() {
		return (this.iState);
	}
	public static void main(String args[] ) throws ParseException{
		EHRBIOCheck dd = new EHRBIOCheck();
		dd.setBirth("1974-05-16");
		Logger.debug(dd.getFeel());
		Logger.debug(dd.getBody());
		Logger.debug(dd.getIntel());
		Logger.debug(dd.getBState());
	}
}
