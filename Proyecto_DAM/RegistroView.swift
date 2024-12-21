import SwiftUI

struct RegistroView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var nombre = ""
    @State private var mensajeError = ""
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Spacer()
            
            // Encabezado
            VStack(spacing: 10) {
                Image(systemName: "person.crop.circle.badge.plus")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.blue)
                
                Text("Crear Cuenta")
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
            
            Spacer().frame(height: 40)
            
            // Formulario
            VStack(spacing: 20) {
                // Campo de Nombre
                HStack {
                    Image(systemName: "person")
                        .foregroundColor(.gray)
                    TextField("Nombre", text: $nombre)
                        .autocapitalization(.words)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).strokeBorder(Color.gray, lineWidth: 1))
                
                // Campo de Email
                HStack {
                    Image(systemName: "envelope")
                        .foregroundColor(.gray)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).strokeBorder(Color.gray, lineWidth: 1))
                
                // Campo de Contraseña
                HStack {
                    Image(systemName: "lock")
                        .foregroundColor(.gray)
                    SecureField("Contraseña", text: $password)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).strokeBorder(Color.gray, lineWidth: 1))
                
                // Botón de Registro
                Button(action: registrarUsuario) {
                    Text("Registrar")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top, 10)
                
                // Mensaje de Error
                if !mensajeError.isEmpty {
                    Text(mensajeError)
                        .foregroundColor(.red)
                        .font(.footnote)
                        .padding(.top, 5)
                }
            }
            .padding(.horizontal, 30)
            
            Spacer()
            
            // Botón para Volver
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Ya tengo una cuenta")
                    .foregroundColor(.blue)
                    .font(.subheadline)
            }
        }
        .padding()
    }
    
    private func registrarUsuario() {
        do {
            try CoreDataManagerUsuario.shared.guardarUsuario(email: email, password: password, nombre: nombre)
            presentationMode.wrappedValue.dismiss()
        } catch {
            mensajeError = "No se pudo registrar. Intenta de nuevo."
        }
    }
}
