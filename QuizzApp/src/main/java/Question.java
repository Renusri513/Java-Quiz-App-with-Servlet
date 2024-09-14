import java.util.ArrayList;
import java.util.List;

public class Question {
    private int quizId;
    private int questionId;
    private String questionText;
    private String typeName;
    private int time;
    private List<Option> options;

    public Question(int quizId, int questionId, String questionText, String typeName,int time) {
        this.quizId = quizId;
        this.questionId = questionId;
        this.questionText = questionText;
        this.typeName = typeName;
        this.setTime(time);
        this.options = new ArrayList<>();
    }

    public int getQuizId() {
        return quizId;
    }

    public void setQuizId(int quizId) {
        this.quizId = quizId;
    }

    public int getQuestionId() {
        return questionId;
    }

    public void setQuestionId(int questionId) {
        this.questionId = questionId;
    }

    public String getQuestionText() {
        return questionText;
    }

    public void setQuestionText(String questionText) {
        this.questionText = questionText;
    }

    public String getTypeName() {
        return typeName;
    }

    public void setTypeName(String typeName) {
        this.typeName = typeName;
    }

    public List<Option> getOptions() {
        return options;
    }

    public void setOptions(List<Option> options) {
        this.options = options;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder("{");
        sb.append("\"quiz_id\":").append(quizId)
          .append(", \"question_id\":").append(questionId)
          .append(", \"question_text\":\"").append(questionText).append('\"')
          .append(", \"type_name\":\"").append(typeName).append('\"')
          .append(", \"time\":\"").append(time).append('\"')
          .append(", \"options\":[");
        
        for (int i = 0; i < options.size(); i++) {
            Option option = options.get(i);
            sb.append(option.toString());
            if (i < options.size() - 1) {
                sb.append(",");
            }
        }
        
        sb.append("]}");
        return sb.toString();
    }

	public int getTime() {
		return time;
	}

	public void setTime(int time) {
		this.time = time;
	}
}
