require 'rails_helper'

describe 'Enrollment from courses API' do
  context 'GET /api/v1/courses/:id/enrollments' do
    it 'should get enrollments from course' do
      instructor = Instructor.create!(name: 'Fulano Sicrano',
                                      email: 'fulano@codeplay.com.br')
      course = Course.create!(name: 'Ruby', description: 'Um curso de Ruby',
                     code: 'RUBYBASIC', price: 10,
                     enrollment_deadline: '22/12/2033', instructor: instructor)
      student = Student.create!(email: 'student@email.com', password: 123456)
      other_student = Student.create!(email: 'johndoe@email.com', password: 123456)
      Enrollment.create!(course: course, price: course.price, student: student)
      Enrollment.create!(course: course, price: course.price, student: other_student)

      get '/api/v1/courses/:id/enrollments', params: { id: course.id }

      expect(response).to have_http_status(200)
      expect(response.content_type).to include('application/json')
      expect(parsed_body.count).to eq(2)
      expect(parsed_body['name']).to eq('Ruby')
      expect(parsed_body["enrollments"][0]["student"]["email"]).to eq('student@email.com')
      expect(parsed_body["enrollments"][1]["student"]["email"]).to eq('johndoe@email.com')
    end
  end

  private

  def parsed_body
    JSON.parse(response.body)
  end
end