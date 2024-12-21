//
//  RegistroView.swift
//  Proyecto_DAM
//
//  Created by DAMII on 14/12/24.
//

import SwiftUI

struct RegistroView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var nombre = ""
    @State private var mensajeError = ""
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Registro").font(.largeTitle)
            
            TextField("Nombre", text: $nombre)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
            
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
            
            TextField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button(action: registrarUsuario) {
                Text("Registrar")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            if !mensajeError.isEmpty {
                Text(mensajeError).foregroundColor(.red)
            }
        }
        .padding()
    }

    
    private func registrarUsuario() {
        do {
            try CoreDataManagerUsuario.shared.guardarUsuario(email: email, password: password, nombre: nombre)
            presentationMode.wrappedValue.dismiss()
        }catch {
            mensajeError = "No se pudo registrar, intenta denuevo"
        }
    }

}
