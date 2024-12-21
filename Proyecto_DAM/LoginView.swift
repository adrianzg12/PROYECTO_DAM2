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
                VStack {
                    Spacer()
                    
                    VStack(spacing: 10) {
                        Image(systemName: "cart")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.blue)
                        
                        Text("Iniciar Sesión")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    }
                    
                    Spacer().frame(height: 40)
                    
                    VStack(spacing: 20) {
                        HStack {
                            Image(systemName: "envelope")
                                .foregroundColor(.gray)
                            TextField("Email", text: $email)
                                .autocapitalization(.none)
                                .keyboardType(.emailAddress)
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).strokeBorder(Color.gray, lineWidth: 1))
                        
                        HStack {
                            Image(systemName: "lock")
                                .foregroundColor(.gray)
                            SecureField("Contraseña", text: $password)
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).strokeBorder(Color.gray, lineWidth: 1))
                        
                        Button(action: iniciarSesion) {
                            Text("Iniciar Sesión")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.top, 10)
                        
                        if !mensajeError.isEmpty {
                            Text(mensajeError)
                                .foregroundColor(.red)
                                .font(.footnote)
                                .padding(.top, 5)
                        }
                    }
                    .padding(.horizontal, 30)
                    
                    Spacer()
                    
                    NavigationLink(destination: RegistroView()) {
                        Text("¿No tienes cuenta? Regístrate")
                            .foregroundColor(.blue)
                            .font(.subheadline)
                    }
                }
                .padding()
            }
        }
    }
    
    private func iniciarSesion() {
        if let usuario = CoreDataManagerUsuario.shared.validarUsuario(email: email, password: password) {
            isLoggedIn = true
        } else {
            mensajeError = "Email o contraseña incorrectos"
        }
    }
}
