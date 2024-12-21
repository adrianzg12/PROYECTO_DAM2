import SwiftUI

struct DetalleArticuloView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var articulo: Articulo
    @State private var showEditView = false
    @State private var showDeleteConfirmation = false

    var body: some View {
        Form {
            Section(header: Text("Detalles del Artículo")) {
                Text("Nombre: \(articulo.nombre ?? "No disponible")")
                Text("Cantidad: \(articulo.cantidad)")
                Text("Prioridad: \(articulo.prioridad ?? "No especificada")")
                Text("Notas adicionales: \(articulo.notas ?? "No hay notas")")
            }

            Section(header: Text("Categoría y Tienda")) {
                Text("Categoría: \(articulo.categoria ?? "No especificada")")
                Text("Tienda: \(articulo.tienda ?? "No especificada")")
            }

            Section {
                Button("Editar Artículo") {
                    showEditView = true
                }
                .foregroundColor(.blue)

                Button("Eliminar Artículo") {
                    showDeleteConfirmation = true
                }
                .foregroundColor(.red)
            }
        }
        .navigationTitle("Detalles del Artículo")
        .sheet(isPresented: $showEditView) {
            EditarArticuloView(articulo: $articulo)
        }
        .alert(isPresented: $showDeleteConfirmation) {
            Alert(
                title: Text("Eliminar Artículo"),
                message: Text("¿Estás seguro de que deseas eliminar este artículo?"),
                primaryButton: .destructive(Text("Eliminar")) {
                    eliminarArticulo()
                },
                secondaryButton: .cancel()
            )
        }
        .navigationBarItems(trailing: Button("Cerrar") {
            presentationMode.wrappedValue.dismiss()
        })
    }

    private func eliminarArticulo() {
        do {
            try CoreDataManagerCompras.shared.eliminarArticulo(articulo: articulo)
            presentationMode.wrappedValue.dismiss()
        } catch {
            print("Error al eliminar artículo: \(error)")
        }
    }
}
