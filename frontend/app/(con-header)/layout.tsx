export default function RootLayout({
    children,
}: Readonly<{
    children: React.ReactNode;
}>) {
    return (
        <>
        <header className="w-full p-5 bg-primary text-white font-bold flex justify-center">
            <nav>

            </nav>
            <div id="logo">
                
            </div>
        </header>
        {children}
        </>
    );
}