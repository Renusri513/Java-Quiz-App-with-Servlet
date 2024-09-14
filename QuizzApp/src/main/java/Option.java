public class Option {
    private int optionId;
    private String optionText;
    private boolean isCorrect; // Add this field

    public Option(int optionId, String optionText, boolean isCorrect) {
        this.optionId = optionId;
        this.optionText = optionText;
        this.isCorrect = isCorrect; // Initialize this field
    }

    @Override
    public String toString() {
        return String.format("{\"option_id\":%d, \"option_text\":\"%s\", \"is_correct\":%b}", 
                             optionId, optionText, isCorrect);
    }

    // Getters and Setters
    public int getOptionId() {
        return optionId;
    }

    public void setOptionId(int optionId) {
        this.optionId = optionId;
    }

    public String getOptionText() {
        return optionText;
    }

    public void setOptionText(String optionText) {
        this.optionText = optionText;
    }

    public boolean isCorrect() {
        return isCorrect;
    }

    public void setCorrect(boolean correct) {
        isCorrect = correct;
    }
}
