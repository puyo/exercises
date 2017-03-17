import java.io.*;
import java.net.*;

class Client {

	// Communication codes.
	public static final int ACKNOWLEDGE = 1;
	public static final int DISCONNECT = 2;
	
	private static String usage = "Usage: java Client <address>";

	private static BufferedReader userInStream = new BufferedReader(new InputStreamReader(System.in));

	private static final int PORTNUM = 1234;

	public static void main(String[] args) {

		InputStream serverInStream = null;
		OutputStream serverOutStream = null;
		int serverInput = 0;
		int clientInput = 0;

		Socket socket = null;
		String address = null;

		// Check the command-line args for the host address
		if (args.length != 1) {
			System.out.println(usage);
			return;
		} else {
			address = args[0];
		}

		// Initialize the socket and streams
		try {
			socket = new Socket(address, PORTNUM);
			serverInStream = socket.getInputStream();
			serverOutStream = socket.getOutputStream();
		} catch (Exception e) {
			System.err.println("Exception: Could not connect to server: " + e.getMessage());
			System.exit(1);
		}

		// Process user input and server responses
		try {
			while ((serverInput = serverInStream.read()) != 0) {

				System.out.println("Server: " + serverInput);

				if (serverInput == DISCONNECT)
					break;

				clientInput = userInStream.read();
				
				System.out.println("Client: " + clientInput);

				serverOutStream.write(clientInput);
				serverOutStream.flush();
			}

		} catch (Exception e) {
			System.err.println("Exception: error trying to talk to server: " + e.getMessage());
		}

		try {
			// Cleanup
			serverInStream.close();
			serverInStream.close();
			socket.close();

		} catch (Exception e) {
			System.err.println("Exception: error trying to disconnect from server: " + e.getMessage());
		}

	}
}
