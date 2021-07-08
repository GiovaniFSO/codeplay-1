module Api
  module V1
    class EnrollmentsController < ActionController::API
      def index
        @course = Course.find(params[:id])
        @enrollments = @course.enrollments
        if @enrollments 
          render json: @course.as_json(include: { enrollments: { include: { student: { only: [:email] } }
                                  }}, only: [:name])
        end
      end
    end
  end
end