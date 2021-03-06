ActiveAdmin.register_page "Resumen" do
  menu priority: 2
  content title: "Testigos online" do

    columns do
      column do
        panel "Testigos online por departamento" do
          data = [
            {
              name: "Online",
              data: Department.order('name asc').where(id: 1..33).collect { |x| [x.name, (x.users.where(online: true).count * 100 / x.users.count.to_f || 1)] }
            },
            {
              name: "Offline",
              data: Department.order('name asc').where(id: 1..33).collect { |x| [x.name, (x.users.where(online: false).count * 100 / x.users.count.to_f || 1)] }
            }
          ]
          render 'bar_graph', { data: data }
          table_for Department.joins(:users).where('users.online = true').group(['departments.id', 'departments.name']).count.each do
            column("Departamento") {| department | department[0][1] }
            column("Logueados") { | department | department.last }
            column("Porcentaje") { | department | "#{department.last * 100 / (Department.find(department[0][0]).users.count.nonzero? || 1)} %" }
          end
        end # End panel
      end
    end

    columns do
      column do
        panel "Testigos Online" do
          columns do
            column do
              users = User.all
              online = users.where(online: true).count
              render 'logins', { number: online , icon: "user" }
            end
            column do
              render 'logins', { number: "#{User.where(online: true).count * 100 / User.count}%", icon: "percent" }
            end
          end
          columns do
            column do
              users = User.all
              online = users.where(online: true).count
              offline = users.where.not(online: true).count
              render 'login_chart', {online: online, offline: offline}
            end
          end
        end # End panel

      end # End column

      column do
        panel "Testigos en el mapa" do
          columns do
            column do
              render 'map_chart'
            end
          end
        end
      end # End column
    end # End columns
  end
end
