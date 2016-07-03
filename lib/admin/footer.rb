module Admin
  class Footer < ActiveAdmin::Views::Footer
    def build
      super
      render('layouts/admin_footer')
    end
   end
end
