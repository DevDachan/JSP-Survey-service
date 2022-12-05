package survey;

import javax.servlet.ServletContext;

import util.DatabaseUtil;

public class SurveyDAO extends DatabaseUtil {
	
	public SurveyDAO(ServletContext application) {
		super(application);
	}
	
	public int addSurvey(String userID) {
		int sid = 0;
		while(true) {
			try {
				double rand = Math.random();
				int randomCode = Integer.parseInt(Double.toString(rand).substring(2, 10));
				String test = "SELECT id FROM survey WHERE id =?";
				psmt = con.prepareStatement(test);
				psmt.setInt(1, randomCode);
				
				rs = psmt.executeQuery();
				if(rs.next()) {
					if(rs.getInt(1) != randomCode) {
						break;
					}
				}else {
					sid = randomCode;
					break;
				}
			}catch(Exception e) {
				e.printStackTrace();
			}
		}
		if(sid != 0) {
			try {
				String query = "INSERT INTO survey_option VALUES(?,'radio',1,1,'Radio')";
				psmt = con.prepareStatement(query);
				psmt.setInt(1, sid);
				psmt.executeUpdate();
				
				query = "INSERT INTO survey_option VALUES(?,'checkbox',2,1,'Checkbox')";
				psmt = con.prepareStatement(query);
				psmt.setInt(1, sid);
				psmt.executeUpdate();
				
				query = "INSERT INTO survey_option VALUES(?,'text',3,1,'Text')";
				psmt = con.prepareStatement(query);
				psmt.setInt(1, sid);
				psmt.executeUpdate();
				
				query = "INSERT INTO option_detail VALUES(?,1,'Title','content','radio')";
				psmt = con.prepareStatement(query);
				psmt.setInt(1, sid);
				psmt.executeUpdate();
				
				query = "INSERT INTO option_detail VALUES(?,2,'Title','content','checkbox')";
				psmt = con.prepareStatement(query);
				psmt.setInt(1, sid);
				psmt.executeUpdate();
				
				query = "INSERT INTO option_detail VALUES(?,3,'Title','content','text')";
				psmt = con.prepareStatement(query);
				psmt.setInt(1, sid);
				psmt.executeUpdate();
				
				
				query = "INSERT INTO survey VALUES(?,'Example',?,'This is content space')";
				psmt = con.prepareStatement(query);
				psmt.setInt(1, sid);
				psmt.setString(2,userID);
				psmt.executeUpdate();
				
				return sid;
			}catch(Exception e) {
				e.printStackTrace();
			}
		}
	
		
		return sid;
	}
	
	
	public int deleteSurvey(String userID, int surveyID) {
		String query = "SELECT admin_id FROM survey WHERE id=?;";
		try {
			psmt = con.prepareStatement(query);
			psmt.setInt(1, surveyID);
				
			rs = psmt.executeQuery();
			if(rs.next()) {
				if(rs.getString(1).equals(userID)) {
					query = "DELETE FROM survey WHERE id=?";
					psmt = con.prepareStatement(query);
					psmt.setInt(1, surveyID);
					psmt.executeUpdate();

					query = "DELETE FROM survey_option WHERE survey_id=?";
					psmt = con.prepareStatement(query);
					psmt.setInt(1, surveyID);
					psmt.executeUpdate();

					query = "DELETE FROM option_detail WHERE survey_id=?";
					psmt = con.prepareStatement(query);
					psmt.setInt(1, surveyID);
					psmt.executeUpdate();
					
					query = "DELETE FROM survey_history WHERE survey_id=?";
					psmt = con.prepareStatement(query);
					psmt.setInt(1, surveyID);
					psmt.executeUpdate();
					
					
					return 1;
					
				}else {
					return 2;
				}
			}
			return 1;
		}catch(Exception e) {
			e.printStackTrace();
		}
		return 0;
		
	}
	
	public int editComponent(int surveyID, int optionNum,int componentNum ,String content) {
		String query = "UPDATE survey_option SET content=? WHERE survey_id = ? AND option_num = ? AND component_num=?;";
		try {
			psmt = con.prepareStatement(query);
			psmt.setString(1, content);
			psmt.setInt(2, surveyID);
			psmt.setInt(3, optionNum);
			psmt.setInt(4, componentNum);
				
			int result = psmt.executeUpdate();
			if(result == 0) {
				return 0;
			}
			return 1;
		}catch(Exception e) {
			e.printStackTrace();
		}
		return 0;
	}
	
	public int editOption(int surveyID, int optionNum ,String content, String type) {
		
		if(type.equals("title")) {
			String query = "UPDATE option_detail SET option_title=? WHERE survey_id = ? AND option_num = ?;";
			try {
				psmt = con.prepareStatement(query);
				psmt.setString(1, content);
				psmt.setInt(2, surveyID);
				psmt.setInt(3, optionNum);
					
				int result = psmt.executeUpdate();
				if(result == 0) {
					return 0;
				}
				return 1;
			}catch(Exception e) {
				e.printStackTrace();
			}
		}else {
			String query = "UPDATE option_detail SET option_content=? WHERE survey_id = ? AND option_num = ?;";
			try {
				psmt = con.prepareStatement(query);
				psmt.setString(1, content);
				psmt.setInt(2, surveyID);
				psmt.setInt(3, optionNum);
					
				int result = psmt.executeUpdate();
				if(result == 0) {
					return 0;
				}
				return 1;
			}catch(Exception e) {
				e.printStackTrace();
			}
			
		}
		return 0;
	}
	
	public int editSurvey(int surveyID, String content, String type) {
		if(type.equals("surveyTitle")) {
			String query = "UPDATE survey SET name=? WHERE id = ?;";
			try {
				psmt = con.prepareStatement(query);
				psmt.setString(1, content);
				psmt.setInt(2, surveyID);
					
				int result = psmt.executeUpdate();
				if(result == 0) {
					return 0;
				}
				return 1;
			}catch(Exception e) {
				e.printStackTrace();
			}
		}else {
			String query = "UPDATE survey SET content=? WHERE id = ?;";
			try {
				psmt = con.prepareStatement(query);
				psmt.setString(1, content);
				psmt.setInt(2, surveyID);
					
				int result = psmt.executeUpdate();
				if(result == 0) {
					return 0;
				}
				return 1;
			}catch(Exception e) {
				e.printStackTrace();
			}
			
		}
		return 0;
		
	}
	
	public int deleteComponent(int surveyID , int optionNum, int componentNum) {
		
		String query = "DELETE FROM survey_option WHERE survey_id = ? AND option_num = ? AND component_num = ?;";
		try {
			psmt = con.prepareStatement(query);
			psmt.setInt(1, surveyID);
			psmt.setInt(2, optionNum);
			psmt.setInt(3, componentNum);
			
			int result = psmt.executeUpdate();
			if(result == 0) {
				return 0;
			}
			
			query = "SELECT COUNT(*) FROM survey_option WHERE survey_id=? AND option_num = ?;";
			psmt = con.prepareStatement(query);
			psmt.setInt(1, surveyID);
			psmt.setInt(2, optionNum);
			rs = psmt.executeQuery();
			if(rs.next()){
				if(rs.getInt(1) == 0) {
					query = "DELETE FROM option_detail WHERE survey_id=? AND option_num = ?;";
					psmt = con.prepareStatement(query);
					psmt.setInt(1, surveyID);
					psmt.setInt(2, optionNum);
					psmt.executeUpdate();
				}
			}
			
			return 1;
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		
		return 0;
		
	}
	public int deleteOption(int surveyID, int optionNum) {
		String query = "DELETE FROM option_detail WHERE survey_id=? AND option_num = ?";
		
		try {
			psmt = con.prepareStatement(query);
			psmt.setInt(1, surveyID);
			psmt.setInt(2, optionNum);
			
			int result = psmt.executeUpdate();
			if(result == 0) {
				return 0;
			}else {
				query = "DELETE FROM survey_option WHERE survey_id=? AND option_num = ?";
				psmt = con.prepareStatement(query);
				psmt.setInt(1, surveyID);
				psmt.setInt(2, optionNum);
				result = psmt.executeUpdate();
				if(result == 0) {
					return 0;
				}else {
					return 1;
				}
				
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return 0;
	}
	
	public int addOption(int surveyID, String optionType) {
		String getquery = "SELECT MAX(option_num) FROM option_detail where survey_id = ?";
		int maxIndex = 0;
		
		try {
			psmt = con.prepareStatement(getquery);
			psmt.setInt(1, surveyID);

			rs = psmt.executeQuery();
			if(rs.next()) {
				maxIndex = rs.getInt(1)+1;
				if(maxIndex == 1) {
					return 0;
				}	
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		String query = "INSERT INTO option_detail VALUES(?,?,'제목','질문 내용',?)";
		try {
			psmt = con.prepareStatement(query);
			psmt.setInt(1, surveyID);
			psmt.setInt(2, maxIndex);
			psmt.setString(3, optionType);

			int result = psmt.executeUpdate();
			query = "INSERT INTO survey_option VALUES(?,?,?,?,'선택 내용');";
			psmt = con.prepareStatement(query);
			psmt.setInt(1, surveyID);
			psmt.setString(2, optionType);
			psmt.setInt(3, maxIndex);
			psmt.setInt(4, 1); // Component number
			psmt.executeUpdate();
			return result;
			
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		
		return 0;
	}
	public int addComponent(int surveyID , int optionNum) {
		String getquery = "SELECT type, MAX(component_num) FROM survey_option where survey_id = ? AND option_num =?;";
		String surveyType="";
		int componentNum = 0;
		try {
			psmt = con.prepareStatement(getquery);
			psmt.setInt(1, surveyID);
			psmt.setInt(2, optionNum);

			rs = psmt.executeQuery();
			if(rs.next()) {
				surveyType = rs.getString(1);
				componentNum = rs.getInt(2)+1;
				if(surveyType==null) {
					return 0;
				}
				if(componentNum==0) {
					return 0;
				}
			}

		}catch(Exception e) {
			e.printStackTrace();
		}
		
		String query = "INSERT INTO survey_option VALUES(?,?,?,?,'New option')";
		try {
			psmt = con.prepareStatement(query);
			psmt.setInt(1, surveyID);
			psmt.setString(2, surveyType);
			psmt.setInt(3, optionNum);
			psmt.setInt(4, componentNum);
			
			int result = psmt.executeUpdate();
			return result;
			
		}catch(Exception e) {
			e.printStackTrace();
		}
		return 0;
	}
	
	public SurveyDTO getSurvey(int sid) {
		SurveyDTO surveyDTO = null;
		try {
			              
			String query = "SELECT * FROM survey WHERE id=?";
			psmt = con.prepareStatement(query);
			psmt.setInt(1, sid);
			
			rs = psmt.executeQuery();
			if(rs.next()) {
				surveyDTO = new SurveyDTO(rs.getInt(1),rs.getString(2),rs.getString(3),rs.getString(4));
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		return surveyDTO;
	}
	
	
	public OptionDTO[] getComponent(int sid) {
		OptionDTO[] survey = null;
		int survey_len = 0;
		String count_survey = "SELECT COUNT(*) FROM survey_option WHERE survey_id=?;";
		try {
			psmt = con.prepareStatement(count_survey);
			psmt.setInt(1, sid);
			rs = psmt.executeQuery();
			if(rs.next()) {
				survey_len = rs.getInt(1);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		String query = "SELECT * FROM survey_option JOIN survey ON (survey_id = id) WHERE survey_id = ?;";
		try {
			psmt = con.prepareStatement(query);
			psmt.setInt(1, sid);
			rs = psmt.executeQuery();

			survey = new OptionDTO[survey_len];
			int i = 0;
			while(rs.next()){ // get survey content
				survey[i] = new OptionDTO(rs.getInt(1),rs.getString(2),rs.getInt(3),rs.getInt(4),rs.getString(5),rs.getString(7));
				i++;
				if(i == survey_len) {
					break;
				}
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		
		return survey;
	}
	public OptionDetailDTO[] getOption(int sid) {
		OptionDetailDTO[] option = null;
		int option_len = 0;
		String optionCountQuery = "SELECT COUNT(*) FROM option_detail WHERE survey_id=?;";
		try {
			psmt = con.prepareStatement(optionCountQuery);
			psmt.setInt(1, sid);
			rs = psmt.executeQuery();
			if(rs.next()) {
				option_len = rs.getInt(1);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		String select_option = "SELECT * FROM option_detail WHERE survey_id = ?;";
		option= new OptionDetailDTO[option_len];
		try {
			psmt = con.prepareStatement(select_option);
			psmt.setInt(1, sid);
			rs = psmt.executeQuery();
		
			int i = 0;
			while(rs.next()){ // get survey content
				option[i++] = new OptionDetailDTO(rs.getInt(1),rs.getInt(2),rs.getString(3),rs.getString(4),rs.getString(5));
				
				if(i == option_len) {
					break;
				}
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		
		return option;
	}

}




