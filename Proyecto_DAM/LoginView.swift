import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var mensajeError = ""
    @State private var isLoggedIn = false
    
    var body: some View {
        
        NavigationView {
            if isLoggedIn {
                ListaComprasView()
            } else {
                VStack(spacing: 20) {
                    Text("Login").font(.largeTitle)
                    
                    TextField("Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    
                    TextField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button(action: iniciarSesion) {
                        Text("Iniciar Sesión")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    if !mensajeError.isEmpty {
                        Text(mensajeError).foregroundColor(.red)
                    }
                    
                    // Nuevo mensaje para redirigir al registro
                    NavigationLink(destination: RegistroView()) {
                        Text("¿No tienes cuenta? Regístrate")
                            .foregroundColor(.blue)
                            .font(.subheadline)
                    }
                    .padding(.top)
                }
            }
        }
    }
    
    private func iniciarSesion() {
        if let usuario = CoreDataManagerUsuario.shared.validarUsuario(email: email, password: password) {
            isLoggedIn = true
        } else {
            mensajeError = "Email o password incorrectos"
        }
    }
}
