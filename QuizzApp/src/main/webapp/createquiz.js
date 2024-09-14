function fetchTopics() {
    fetch('GetTopicServlet')
        .then(response => response.json())
        .then(data => {
            let topicSelect = document.getElementById('topic');
            topicSelect.innerHTML = '<option value="">Select a topic</option>';
            data.forEach(topic => {
                let option = document.createElement('option');
                option.value = topic.topic_id;
                option.textContent = topic.topic_name;
                topicSelect.appendChild(option);
            });
        })
        .catch(error => {
            console.error('Error fetching topics:', error);
        });
}

function toggleAdditionalFields() {
    var topic = document.getElementById('topic').value;
    var quizName = document.getElementById('quizName').value;
    var difficulty = document.getElementById('difficulty').value;

    if (topic && quizName && difficulty) {
        document.getElementById('additionalFields').style.display = 'block';
    } else {
        document.getElementById('additionalFields').style.display = 'none';
    }
}

function addOption(questionIndex) {
    var optionsContainer = document.getElementById('optionsContainer' + questionIndex);
    var optionCount = optionsContainer.querySelectorAll('input[type="text"]').length + 1;
    var newOption = '<div><input type="text" name="questions[' + questionIndex + '][options][]" placeholder="Option ' + optionCount + '" required></div>';
    optionsContainer.insertAdjacentHTML('beforeend', newOption);
    updateCorrectOptions(questionIndex);
}

function updateCorrectOptions(questionIndex) {
    var questionTypeElement = document.getElementById('questionType' + questionIndex);
    if (!questionTypeElement) {
        console.error('Question type element not found for index:', questionIndex);
        return;
    }

    var questionType = questionTypeElement.value;
    var correctOptionsContainer = document.getElementById('correctOptionsContainer' + questionIndex);
    correctOptionsContainer.innerHTML = '';

    if (questionType) {
        var options = document.querySelectorAll('#optionsContainer' + questionIndex + ' input[name="questions[' + questionIndex + '][options][]"]');
        options.forEach(function(option, index) {
            var optionHTML = '<div><input type="' + (questionType === 'single' ? 'radio' : 'checkbox') + '" name="questions[' + questionIndex + '][correctOptions][]" value="' + option.value + '" required><label>' + option.value + '</label></div>';
            correctOptionsContainer.insertAdjacentHTML('beforeend', optionHTML);
        });
    }
}

function addQuestion() {
    var questionsContainer = document.getElementById('questionsContainer');
    var questionIndex = questionsContainer.querySelectorAll('.question-container').length;

    var newQuestion = '' +
        '<div class="question-container">' +
            '<div class="form-group">' +
                '<label for="questionType' + questionIndex + '">Question Type:</label>' +
                '<select id="questionType' + questionIndex + '" name="questions[' + questionIndex + '][questionType]" onchange="updateCorrectOptions(' + questionIndex + ')" required>' +
                    '<option value="">Select question type</option>' +
                    '<option value="single">Single Selection</option>' +
                    '<option value="multiple">Multiple Selection</option>' +
                '</select>' +
            '</div>' +
            '<div class="form-group">' +
                '<label for="question' + questionIndex + '">Question:</label>' +
                '<input type="text" id="question' + questionIndex + '" name="questions[' + questionIndex + '][question]" required>' +
            '</div>' +
            '<div class="form-group options">' +
                '<label>Options:</label>' +
                '<div id="optionsContainer' + questionIndex + '">' +
                    '<div><input type="text" name="questions[' + questionIndex + '][options][]" placeholder="Option 1" required></div>' +
                    '<button type="button" onclick="addOption(' + questionIndex + ')">Add More Options</button>' +
                '</div>' +
            '</div>' +
            '<div class="form-group correct-options">' +
                '<label>Correct Options:</label>' +
                '<div id="correctOptionsContainer' + questionIndex + '">' +
                    '<!-- Correct options will be added dynamically here -->' +
                '</div>' +
            '</div>' +
            // New time input field for each question
            '<div class="form-group">' +
                '<label for="time' + questionIndex + '">Time (in seconds):</label>' +
                '<input type="number" id="time' + questionIndex + '" name="questions[' + questionIndex + '][time]" placeholder="Enter time in seconds" class="form-control" required>' +
            '</div>' +
            '<button type="button" onclick="removeQuestion(' + questionIndex + ')">Remove Question</button>' +
        '</div>';
    questionsContainer.insertAdjacentHTML('beforeend', newQuestion);
}

function removeQuestion(questionIndex) {
    var questionContainer = document.querySelector('#questionsContainer .question-container:nth-child(' + (questionIndex + 1) + ')');
    if (questionContainer) {
        questionContainer.remove();
    }
}


// Call fetchTopics when the page loads
document.addEventListener('DOMContentLoaded', function() {
    fetchTopics();
    document.getElementById('quizForm').addEventListener('change', toggleAdditionalFields);
    document.getElementById('addQuestionButton').addEventListener('click', addQuestion);
});
